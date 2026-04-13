# データ保存ツール選定ガイド

## 目次

1. [選定フローチャート](#選定フローチャート)
2. [ツール別特性まとめ](#ツール別特性まとめ)
3. [Google スプレッドシート](#google-スプレッドシート)
4. [SQLite](#sqlite)
5. [Supabase（無料PostgreSQL）](#supabase無料postgresql)
6. [PlanetScale / Turso（無料MySQL/SQLite）](#planetscale--turso無料mysqlsqlite)
7. [BigQuery](#bigquery)
8. [dbt との組み合わせ](#dbt-との組み合わせ)
9. [よくある相談パターン](#よくある相談パターン)

---

## 選定フローチャート

```
データを保存したい
    ↓
非エンジニアが直接操作？
  YES → スプレッドシート（Google Sheets）を検討
  NO  ↓
     データ量・クエリの複雑さは？
       小規模・シンプル → SQLite（ファイルDB）
       中規模・Webアプリ → Supabase / PlanetScale（無料枠あり）
       大規模分析・DWH → BigQuery
       ↓
     予算は？
       無料 → Supabase（500MBまで）/ SQLite / Turso
       低コスト → Supabase Pro / PlanetScale
       従量課金OK → BigQuery / Cloud SQL
```

---

## ツール別特性まとめ

| ツール | 無料枠 | 向いている用途 | 向いていない用途 |
|---|---|---|---|
| Google Sheets | 無制限 | 非エンジニア向け・小規模マスタ | 大量データ・複雑JOIN |
| SQLite | 完全無料 | ローカル開発・組み込み・小規模アプリ | 並行書き込み・大規模 |
| Supabase | 500MB・2プロジェクト | Webアプリ・REST API付き | 超大規模データ |
| PlanetScale | 10GB（無料終了後は有料） | MySQL互換・スケール重視 | - |
| Turso | 9GB | SQLite互換・エッジ | - |
| BigQuery | 10GB/月クエリ無料 | 大規模分析・DWH | 低レイテンシのトランザクション |
| Cloud SQL | 無料枠なし | フルマネージドRDBMS | コスト重視 |

---

## Google スプレッドシート

### 向いているケース

- **非エンジニアがデータを直接入力・閲覧する**
- 数百〜数千行程度の小規模マスタデータ
- Excel からの移行
- 簡単なフォーム連携（Google Forms）
- プロトタイプ・MVP フェーズ

### 向いていないケース

- 10万行を超えるデータ（動作が重くなる）
- 複数テーブルの複雑な JOIN
- 高頻度な更新・リアルタイム性が必要
- アクセス制御が細かく必要

### データベースとして使う際のコツ

```
シート設計のベストプラクティス:
- 1シート1エンティティ（マスタ、トランザクション等を分ける）
- 1行目はヘッダー行（固定しておく）
- ID列を必ず設ける（A列に連番 or UUID）
- セルの結合は禁止（データ取得が困難になる）
- ドロップダウンリスト（データの入力規則）で値を制限する

BigQuery 連携:
- BigQuery のデータ取得元として Sheets を使える
  （外部テーブルまたは Looker Studio 経由）
- 小さなマスタテーブルを Sheets で管理 → BigQuery に結合するパターンが有効
```

---

## SQLite

### 向いているケース

- **ローカルアプリ・CLI ツール**
- 開発環境のプロトタイプ
- 組み込みデバイス・モバイルアプリ（iOS/Android）
- 単一ユーザーが使う小規模ツール
- 設定ファイルの代替

### 向いていないケース

- 複数の書き込みが同時発生（並行書き込みはロックが発生）
- Webサービスの本番DB（スケールしない）

### 基本的な使い方

```python
import sqlite3

conn = sqlite3.connect('myapp.db')
cursor = conn.cursor()

cursor.execute('''
    CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL
    )
''')
conn.commit()
```

### Turso（SQLite互換・クラウド）

- SQLite の構文をそのままクラウドで使える
- 無料枠: 9GB ストレージ・10億行読み取り/月
- エッジロケーション対応
- 小規模 Web アプリなら Supabase の代替になる

---

## Supabase（無料PostgreSQL）

### 向いているケース

- **Web アプリ・モバイルアプリのバックエンド**
- REST API・GraphQL が自動生成される
- リアルタイムサブスクリプション（WebSocket）
- 認証機能付きで使いたい
- PostgreSQL の全機能が使いたい

### 無料枠の制限

- ストレージ: 500MB
- プロジェクト数: 2つ
- 非アクティブ7日でポーズ（有料プランで解除）
- APIリクエスト: 制限なし

### 設計時の注意

```sql
-- Supabase は PostgreSQL なので全機能が使える
-- Row Level Security (RLS) でユーザー別アクセス制御
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can only see own posts"
  ON posts FOR SELECT
  USING (auth.uid() = user_id);

-- インデックスは必ず貼る（デフォルトでは主キーのみ）
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_created_at ON posts(created_at DESC);
```

---

## PlanetScale / Turso（無料MySQL/SQLite）

### PlanetScale

- MySQL 互換（Vitess 基盤）
- 水平スケールが得意
- ブランチ機能でスキーマ変更が安全
- 注意: 2024年から無料枠が廃止（有料のみ）

### Turso

- SQLite 互換
- 無料枠が広い（9GB・10億行読み取り）
- エッジコンピューティング対応
- 小規模アプリに最適

---

## BigQuery

### 向いているケース

- **大規模データの分析（GByte〜TByte）**
- バッチ処理・ETL/ELT パイプライン
- BI ツール連携（Looker Studio 等）
- 機械学習のデータ基盤
- ログ・イベントデータの分析

### 向いていないケース

- 低レイテンシのトランザクション（OLTP）
- 小頻度クエリ（無料枠は10GB/月だが超過はコスト発生）
- 単一行の高速 UPDATE/DELETE（BigQuery は行指向ではなく列指向）

### コスト管理

- オンデマンド: スキャンしたバイト数で課金（$6.25/TB）
- フラットレート: 固定月額（高コストだが予測可能）
- **パーティション設定で不要なスキャンを削減するのが最重要**

→ 詳細は `references/bigquery-specifics.md` を参照。

---

## dbt との組み合わせ

BigQuery + dbt の組み合わせはデータウェアハウス構築の王道。

### レイヤー設計

```
Raw Layer（生データ）
  → Staging Layer（dbt models/staging/）：型変換・名前統一
  → Intermediate Layer（dbt models/intermediate/）：中間集計
  → Mart Layer（dbt models/marts/）：ビジネス用途別の最終テーブル
```

### マテリアライズ戦略

| レイヤー | マテリアライズ | 理由 |
|---|---|---|
| Staging | view または table | 更新が多い・使用頻度低 |
| Intermediate | view または ephemeral | 再利用性重視 |
| Mart | table または incremental | 分析クエリのパフォーマンス |

---

## よくある相談パターン

### 「個人の家計簿を管理したい」

→ **Google Sheets が最適**。無料・非技術者でも使える。データが増えたら Supabase + シンプルなフロントエンドを検討。

### 「小さなECサイトを作りたい」

→ **Supabase**（無料枠で十分）。PostgreSQL で認証・ストレージ・API が全部揃う。

### 「社内のマスタデータをチームで管理したい」

→ **Google Sheets**（小規模・非エンジニア向け）or **Supabase**（エンジニアが管理・APIアクセスが必要な場合）。

### 「数億件のログを分析したい」

→ **BigQuery**。Google Cloud Storage から読み込むだけで大規模分析ができる。

### 「ローカルで動くCLIツールにDB機能を追加したい」

→ **SQLite**。ファイル1つでDB完結・インストール不要。
