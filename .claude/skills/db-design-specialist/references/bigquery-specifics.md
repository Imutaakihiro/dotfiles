# BigQuery 特有の設計パターン

## 目次

1. [BigQuery の特性を理解する](#bigqueryの特性を理解する)
2. [パーティション設計](#パーティション設計)
3. [クラスタリング設計](#クラスタリング設計)
4. [スキーマ設計（ネスト・繰り返し）](#スキーマ設計ネスト繰り返し)
5. [コスト最適化](#コスト最適化)
6. [アンチパターン](#アンチパターン)
7. [DWH レイヤー設計](#dwh-レイヤー設計)

---

## BigQuery の特性を理解する

BigQuery は **列指向のデータウェアハウス**。通常の RDBMS とは設計思想が大きく異なる。

| 特性 | BigQuery | RDBMS（PostgreSQL等） |
|---|---|---|
| 処理方式 | 列指向（Columnar） | 行指向（Row-based） |
| 強み | 大規模集計・分析（TB〜PB） | トランザクション・低レイテンシ |
| 弱み | 単行UPDATE/DELETE・低レイテンシ | 超大規模スキャン |
| インデックス | なし（パーティション・クラスタで代替） | 充実 |
| JOIN コスト | 高い（シャッフル発生） | 比較的低い |
| 正規化 | 非正規化推奨（ネスト型） | 正規化推奨 |

---

## パーティション設計

**BigQuery ではパーティション設定が必須と考える。** スキャンバイト数 = コストに直結するため。

### パーティション種別

```sql
-- ① 日付/タイムスタンプ列によるパーティション（最も一般的）
CREATE TABLE `project.dataset.events`
PARTITION BY DATE(event_timestamp)
AS SELECT ...;

-- ② 整数範囲パーティション
CREATE TABLE `project.dataset.users`
PARTITION BY RANGE_BUCKET(age, GENERATE_ARRAY(0, 100, 10));

-- ③ 取り込み時間パーティション（event_timestamp が不要な場合）
CREATE TABLE `project.dataset.logs`
PARTITION BY _PARTITIONDATE;
```

### パーティション設計の判断基準

| 状況 | 推奨パーティションキー |
|---|---|
| 時系列イベントデータ | `DATE(event_timestamp)` or `DATE(created_at)` |
| 日次バッチで更新するテーブル | `DATE(updated_date)` |
| パーティションキーが明確でない | 取り込み時間パーティション |

### WHERE 句でパーティションプルーニングを効かせる

```sql
-- 良い例（パーティションプルーニングが効く）
SELECT * FROM events
WHERE DATE(event_timestamp) >= '2024-01-01'
  AND DATE(event_timestamp) < '2024-02-01';

-- 悪い例（全パーティションをスキャン）
SELECT * FROM events
WHERE EXTRACT(YEAR FROM event_timestamp) = 2024;  -- 関数適用でプルーニング不可

-- 注意: `event_timestamp >= TIMESTAMP('2024-01-01')` はプルーニングが効く
```

### パーティション有効期限

ログ等の古いデータを自動削除したい場合：

```sql
ALTER TABLE `project.dataset.logs`
SET OPTIONS (partition_expiration_days = 365);
```

---

## クラスタリング設計

パーティションの中をさらに物理的にソートする仕組み。**パーティションと組み合わせて使う**。

```sql
CREATE TABLE `project.dataset.events`
PARTITION BY DATE(event_timestamp)
CLUSTER BY user_id, event_type;
```

### クラスタリングキーの選び方

- **WHERE 句で等値フィルタによく使う列**（選択性が高い列が効果的）
- **GROUP BY でよく使う列**
- 最大4列まで指定可能（左から順に効果が高い）

### クラスタリングの効果が出るクエリ

```sql
-- user_id でフィルタ → クラスタリングが効く
SELECT * FROM events
WHERE DATE(event_timestamp) = '2024-01-15'
  AND user_id = 12345;

-- user_id + event_type でフィルタ → さらに効果的
SELECT * FROM events
WHERE DATE(event_timestamp) = '2024-01-15'
  AND user_id = 12345
  AND event_type = 'purchase';
```

---

## スキーマ設計（ネスト・繰り返し）

BigQuery は **ARRAY（繰り返し）と STRUCT（ネスト）** をネイティブサポート。
これにより **JOIN なしで非正規化データを効率的に格納できる**。

### 従来の正規化テーブル vs ネスト型

```sql
-- 正規化（RDBMS 的）: JOIN が必要
orders テーブル: order_id, user_id, created_at
order_items テーブル: order_id, product_id, quantity, price

-- BigQuery のネスト型: JOIN 不要
CREATE TABLE orders (
  order_id STRING,
  user_id STRING,
  created_at TIMESTAMP,
  items ARRAY<STRUCT<
    product_id STRING,
    quantity INT64,
    price NUMERIC
  >>
);
```

### ネスト型のクエリ

```sql
-- UNNEST で配列を展開
SELECT
  o.order_id,
  o.user_id,
  item.product_id,
  item.quantity,
  item.price
FROM orders o
CROSS JOIN UNNEST(o.items) AS item;

-- 配列内の集計（UNNEST なしで可能）
SELECT
  order_id,
  (SELECT SUM(item.price * item.quantity) FROM UNNEST(items) AS item) AS total_amount
FROM orders;
```

### いつネスト型を使うか

| 状況 | 推奨 |
|---|---|
| 親エンティティと子エンティティが常にセットでアクセスされる | ネスト型 |
| 子エンティティが単独でアクセスされることがある | 別テーブル |
| 子エンティティの件数が多い（数千件/親） | 別テーブル or パーティション分割 |
| ストリーミングINSERTで追記される | ネスト型は避ける |

---

## コスト最適化

### スキャンバイト削減のルール

1. **SELECT * を避ける** — 必要な列のみ SELECT
2. **パーティション列を WHERE に必ず含める**
3. **クラスタリングキーを WHERE に含める**
4. **マテリアライズドビューを活用**（繰り返し実行するクエリ）

```sql
-- 悪い例（全列・全パーティションスキャン）
SELECT * FROM events;

-- 良い例（必要列のみ・パーティションプルーニング）
SELECT user_id, event_type, event_timestamp
FROM events
WHERE DATE(event_timestamp) >= '2024-01-01';
```

### テーブルのコスト確認

```sql
-- テーブルのサイズとパーティション数を確認
SELECT
  table_name,
  size_bytes / POW(10, 9) AS size_gb,
  row_count,
  partition_count
FROM `project.dataset.INFORMATION_SCHEMA.PARTITIONS`
GROUP BY 1, 2, 3;
```

### クエリコストの事前確認

BigQuery コンソールでクエリを実行前に「ドライラン」実行 → スキャンバイト数を確認できる。

```bash
# bq コマンドで事前確認
bq query --dry_run --nouse_legacy_sql 'SELECT ...'
```

---

## アンチパターン

### ① パーティションなしの大きなテーブル

```sql
-- NG: パーティションなし
CREATE TABLE `project.dataset.events` (
  event_id STRING,
  event_timestamp TIMESTAMP,
  ...
);

-- OK: パーティションあり
CREATE TABLE `project.dataset.events`
PARTITION BY DATE(event_timestamp)
(...)
```

### ② 小さなテーブルへの頻繁なクエリ

BigQuery は1クエリ最低10MBをスキャンとみなす。小さなテーブルは Sheets 管理 + BigQuery 外部テーブルや、dbt のシードファイルで管理する方が安い。

### ③ DML（UPDATE/DELETE）の多用

```sql
-- BigQuery の UPDATE は行全体を書き換えるためコストが高い
UPDATE events SET status = 'processed' WHERE event_id = '123';  -- 避ける

-- 代わりに INSERT + MERGE パターン、または追記型テーブルを検討
MERGE events AS target
USING (SELECT '123' AS event_id, 'processed' AS status) AS source
ON target.event_id = source.event_id
WHEN MATCHED THEN UPDATE SET status = source.status;
```

### ④ 不必要な JOIN

BigQuery は JOIN でシャッフルが発生しコストが高い。ネスト型や事前結合テーブルで対処する。

### ⑤ WHERE なしでのクエリ

パーティション列・クラスタリング列なしの全件スキャンは高コスト。必ず適切なフィルタを追加する。

---

## DWH レイヤー設計

BigQuery + dbt での標準的なレイヤー構成：

```
sources（生データ）
  ↓
staging（stg_）
  - 型変換・命名規則統一
  - ソーステーブル1つに対して1つの staging モデル
  - MATERIALIZED: view
  ↓
intermediate（int_）
  - 中間結合・計算
  - 複数の staging を結合
  - MATERIALIZED: view or ephemeral
  ↓
marts（fct_ / dim_）
  - ファクトテーブル (fct_): トランザクション・イベント
  - ディメンションテーブル (dim_): マスタ・属性
  - MATERIALIZED: table or incremental
```

### インクリメンタルモデル（増分更新）

```sql
-- dbt incremental model で差分のみ処理
{{ config(
    materialized='incremental',
    partition_by={'field': 'event_date', 'data_type': 'date'},
    cluster_by=['user_id', 'event_type'],
    incremental_strategy='insert_overwrite'
) }}

SELECT
    event_id,
    DATE(event_timestamp) AS event_date,
    user_id,
    event_type
FROM {{ source('raw', 'events') }}
{% if is_incremental() %}
WHERE DATE(event_timestamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)
{% endif %}
```
