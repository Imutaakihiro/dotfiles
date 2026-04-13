# 物理設計ガイド

## 目次

1. [データ型の選択](#データ型の選択)
2. [インデックス設計](#インデックス設計)
3. [パーティショニング](#パーティショニング)
4. [主キー設計](#主キー設計)
5. [NULL とデフォルト値](#null-とデフォルト値)
6. [制約の活用](#制約の活用)

---

## データ型の選択

### 整数型

| 型 | 範囲 | 用途 |
|---|---|---|
| TINYINT | -128〜127 | フラグ、小さなコード |
| SMALLINT | -32768〜32767 | 選択肢が少ないID |
| INT | 約±21億 | 一般的なID・カウンタ |
| BIGINT | 約±922京 | 大量データのID、Unix timestamp |

**金額には使わない**（小数がある場合は DECIMAL）

### 文字列型

| 型 | 特性 | 用途 |
|---|---|---|
| CHAR(n) | 固定長・パディング | 固定長コード（郵便番号、ISO等） |
| VARCHAR(n) | 可変長 | 一般的な文字列 |
| TEXT | 上限なし | 長い文章 |

- 上限が決まっている列は VARCHAR(n)（ストレージ最適化とバリデーション兼用）
- 上限不明の場合は TEXT

### 数値型

| 型 | 精度 | 用途 |
|---|---|---|
| DECIMAL(p,s) / NUMERIC | 正確 | **金額・重量など精度が必要なもの** |
| FLOAT / DOUBLE | 近似値 | 科学計算・座標（丸め誤差許容） |

**ルール: 金額・財務データには必ず DECIMAL を使う**

### 日時型

| 型 | 特性 | 用途 |
|---|---|---|
| DATE | 日付のみ | 誕生日、イベント日 |
| TIME | 時刻のみ | 営業時間 |
| DATETIME | 日時（タイムゾーンなし） | MySQL ローカル時刻 |
| TIMESTAMP | Unix時刻ベース | タイムゾーン考慮する場合 |
| TIMESTAMPTZ | タイムゾーン付き | PostgreSQL推奨 |

**ルール: アプリが複数タイムゾーンを扱う場合は UTC で統一して保存**

---

## インデックス設計

### インデックスが効果的なケース

```sql
-- ① 頻繁に WHERE に使われる列（選択性が高いほど効果的）
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- ② 複合インデックス：等値条件 → 範囲条件の順
CREATE INDEX idx_orders_user_status ON orders(user_id, status, created_at);
-- user_id = ? AND status = ? AND created_at >= ? で効果的

-- ③ 外部キー（JOIN を高速化）
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- ④ ORDER BY に使われる列（ソートを避ける）
CREATE INDEX idx_articles_published_at ON articles(published_at DESC);
```

### 複合インデックスの列順序の法則

1. **等値条件（=）の列を先に**
2. **範囲条件（>, <, BETWEEN）の列を後に**
3. **ORDER BY に使う列を最後に**

```sql
-- クエリ: WHERE user_id = 1 AND status = 'active' AND created_at >= '2024-01-01'
-- 良い順序:
CREATE INDEX idx ON orders(user_id, status, created_at);
--   user_id: 等値 → status: 等値 → created_at: 範囲

-- 悪い順序（範囲条件が途中に来ると後続列は使われない）:
CREATE INDEX idx ON orders(created_at, user_id, status);
```

### インデックスが効かないケース

```sql
-- ① 関数適用（インデックスはある値を見るため）
WHERE YEAR(created_at) = 2024  -- NG
WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01'  -- OK

-- ② 先頭ワイルドカード LIKE
WHERE name LIKE '%田中%'  -- NG（全文検索インデックスが必要）
WHERE name LIKE '田中%'   -- OK

-- ③ カーディナリティが低い列（性別 M/F など）
-- インデックスより全件スキャンの方が速いことがある

-- ④ OR 条件（UNION に書き換えるとインデックスが使える場合）
WHERE status = 'A' OR status = 'B'  -- 複合インデックスが効かない
```

### カバリングインデックス（Covering Index）

クエリが必要とするすべての列をインデックスが含む場合、テーブルへのアクセスが不要になる。

```sql
-- クエリ: SELECT user_id, status, created_at FROM orders WHERE user_id = 1
-- カバリングインデックス（SELECT 列をすべて含む）
CREATE INDEX idx_covering ON orders(user_id, status, created_at);
```

---

## パーティショニング

大量データのテーブルを物理的に分割してクエリを高速化する。

### パーティション種別

| 種別 | 分割基準 | 向いているケース |
|---|---|---|
| レンジパーティション | 値の範囲（日付等） | 時系列データ・ログ |
| リストパーティション | 特定の値（地域コード等） | カテゴリが固定 |
| ハッシュパーティション | ハッシュ値 | 均等分散 |
| コンポジット | 上記の組み合わせ | 複合条件 |

### レンジパーティションの例（MySQL）

```sql
CREATE TABLE orders (
  order_id INT,
  created_at DATE,
  ...
) PARTITION BY RANGE (YEAR(created_at)) (
  PARTITION p2022 VALUES LESS THAN (2023),
  PARTITION p2023 VALUES LESS THAN (2024),
  PARTITION p2024 VALUES LESS THAN (2025),
  PARTITION pmax  VALUES LESS THAN MAXVALUE
);
```

### パーティションプルーニング

WHERE 句にパーティションキーを含めることで、不要なパーティションをスキップできる。

```sql
-- これはパーティションプルーニングが効く
SELECT * FROM orders WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01';

-- パーティションキーを関数で変換するとプルーニングが効かない場合がある
SELECT * FROM orders WHERE YEAR(created_at) = 2024;  -- 要確認
```

### BigQuery のパーティション設計

BigQuery では必ずパーティション設定を検討する（コスト・パフォーマンスに直結）。
→ 詳細は `references/bigquery-specifics.md` を参照。

---

## 主キー設計

### 代理キー（サロゲートキー）の選択肢

| 方式 | メリット | デメリット | 推奨シーン |
|---|---|---|---|
| 連番（AUTO_INCREMENT / SERIAL） | シンプル・高速 | 分散DBで採番競合 | 単一DBで十分な規模 |
| UUID v4 | 分散でも一意 | 可読性なし・インデックス断片化 | マイクロサービス・分散DB |
| UUID v7 | 時系列順・分散対応 | 新しい（2023年〜） | 分散DB + 時系列が必要 |
| ULID | 時系列順・URL-safe | ライブラリ依存 | UUID v7 の代替 |
| Snowflake ID | 時系列順・分散対応 | 仕組みが複雑 | 大規模分散システム |

**推奨: 単一 DB なら BIGINT AUTO_INCREMENT、分散なら UUID v7 または ULID**

---

## NULL とデフォルト値

### NOT NULL を基本とする

原則として列は NOT NULL にし、NULL を許可する場合はその理由を明確にする。

```sql
-- 悪い例（何でも NULL 可）
CREATE TABLE users (
  user_id INT,
  name VARCHAR(100),
  email VARCHAR(200),
  age INT
);

-- 良い例
CREATE TABLE users (
  user_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(200) NOT NULL,
  age INT  -- 登録時に不明の場合があるため NULL 許可（コメントで明示）
);
```

### デフォルト値の活用

```sql
status VARCHAR(20) NOT NULL DEFAULT 'active',
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
is_deleted BOOLEAN NOT NULL DEFAULT FALSE
```

---

## 制約の活用

DB の制約で保証できることはアプリに頼らず DB で保証する。

```sql
-- CHECK 制約：値の範囲・パターン制限
price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
email VARCHAR(200) NOT NULL CHECK (email LIKE '%@%'),
status VARCHAR(20) NOT NULL CHECK (status IN ('active', 'inactive', 'deleted')),

-- UNIQUE 制約
UNIQUE (email),
UNIQUE (user_id, role_id),  -- 複合ユニーク

-- 外部キー制約（CASCADE の設定に注意）
FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE
```

### CASCADE の選択基準

| オプション | 動作 | 推奨シーン |
|---|---|---|
| RESTRICT | 親削除を拒否 | 参照整合性を厳しく保つ（デフォルト推奨） |
| CASCADE | 親削除で子も削除 | 所有関係（注文と注文明細等） |
| SET NULL | 親削除で外部キーを NULL に | 任意の参照（担当者がいなくなっても記録を残す）|
| NO ACTION | RESTRICT と同様（遅延評価） | トランザクション内で後から整合させる場合 |
