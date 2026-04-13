# 設計アンチパターン集

## 目次

1. [EAV（エンティティ・属性・値）パターン](#eav-エンティティ属性値-パターン)
2. [ポリモーフィック関連](#ポリモーフィック関連)
3. [マルチカラムアトリビュート](#マルチカラムアトリビュート)
4. [コンマ区切りリスト](#コンマ区切りリスト)
5. [IDリクワイアド（無意味な主キー）](#idリクワイアド無意味な主キー)
6. [ツリー構造の誤った表現](#ツリー構造の誤った表現)
7. [ダブルミーニング列](#ダブルミーニング列)
8. [NULL の乱用](#null-の乱用)
9. [浮動小数点で金額を扱う](#浮動小数点で金額を扱う)
10. [過剰インデックス・インデックス不足](#過剰インデックスインデックス不足)

---

## EAV（エンティティ・属性・値）パターン

### 問題のある設計

```sql
-- 何でも入れられる「万能テーブル」
CREATE TABLE attributes (
  entity_id INT,
  attr_name VARCHAR(50),
  attr_value TEXT  -- 全部 TEXT で格納
);
```

### なぜ問題か

- データ型の保証ができない（数値なのに文字列で入る）
- NOT NULL 制約・デフォルト値が使えない
- 特定属性を取り出すのに複雑な pivot クエリが必要
- 外部キー制約が実質無効

### 改善案

**案A: 固定カラム**（属性数が少なく固定の場合）
```sql
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  price DECIMAL(10,2),
  weight_kg DECIMAL(5,2)
);
```

**案B: JSON カラム**（属性が可変で DB がサポートしている場合）
```sql
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  attributes JSONB  -- PostgreSQL の場合
);
```

**案C: サブタイプテーブル**（エンティティ種別が決まっている場合）
```sql
CREATE TABLE products (product_id INT PRIMARY KEY, name VARCHAR(100));
CREATE TABLE physical_products (product_id INT REFERENCES products, weight_kg DECIMAL);
CREATE TABLE digital_products (product_id INT REFERENCES products, download_url TEXT);
```

---

## ポリモーフィック関連

### 問題のある設計

```sql
-- コメントが複数の対象に紐づく「なんでも参照」
CREATE TABLE comments (
  comment_id INT PRIMARY KEY,
  content TEXT,
  entity_type VARCHAR(20),  -- 'post' or 'video' or 'photo'
  entity_id INT             -- 外部キー制約が貼れない
);
```

### なぜ問題か

- 外部キー制約を設定できない（参照整合性が保証できない）
- `entity_type` の値が増えると管理が困難
- JOIN 時に `entity_type` によって結合先が変わり複雑

### 改善案

**案A: 専用中間テーブル**
```sql
CREATE TABLE post_comments   (comment_id INT, post_id INT);
CREATE TABLE video_comments  (comment_id INT, video_id INT);
```

**案B: 共通親テーブル**
```sql
CREATE TABLE content (content_id INT PRIMARY KEY, content_type VARCHAR(20));
CREATE TABLE posts  (content_id INT REFERENCES content, ...);
CREATE TABLE videos (content_id INT REFERENCES content, ...);
CREATE TABLE comments (content_id INT REFERENCES content, body TEXT);
```

---

## マルチカラムアトリビュート

### 問題のある設計

```sql
CREATE TABLE users (
  user_id INT PRIMARY KEY,
  phone1 VARCHAR(20),
  phone2 VARCHAR(20),
  phone3 VARCHAR(20)
);
```

### なぜ問題か

- 電話番号が4件になった時に ALTER TABLE が必要
- 空の列が増える（スペースの無駄）
- 特定の電話番号を検索するのに OR 条件が増える

### 改善案

```sql
CREATE TABLE user_phones (
  user_id INT REFERENCES users,
  phone_type VARCHAR(20),  -- 'mobile', 'home', 'work'
  phone_number VARCHAR(20),
  PRIMARY KEY (user_id, phone_type)
);
```

---

## コンマ区切りリスト

### 問題のある設計

```sql
CREATE TABLE articles (
  article_id INT PRIMARY KEY,
  tags VARCHAR(500)  -- "python,database,sql"
);
```

### なぜ問題か

- 特定タグの検索に `LIKE '%python%'` が必要でインデックスが効かない
- タグの追加・削除がアプリ側での文字列操作になる
- 参照整合性が保証できない

### 改善案

```sql
CREATE TABLE tags (tag_id INT PRIMARY KEY, name VARCHAR(50));
CREATE TABLE article_tags (
  article_id INT REFERENCES articles,
  tag_id INT REFERENCES tags,
  PRIMARY KEY (article_id, tag_id)
);
```

---

## IDリクワイアド（無意味な主キー）

### 問題のある設計

```sql
-- 中間テーブルに不要なサロゲートキーを追加する
CREATE TABLE user_roles (
  id INT PRIMARY KEY AUTO_INCREMENT,  -- 不要
  user_id INT,
  role_id INT
);
```

### なぜ問題か

- 中間テーブルの主キーは `(user_id, role_id)` の複合キーで十分
- 余分なインデックスが増えパフォーマンスに影響
- `(user_id, role_id)` の一意性制約を別途つけないと重複挿入可能

### 改善案

```sql
CREATE TABLE user_roles (
  user_id INT REFERENCES users,
  role_id INT REFERENCES roles,
  PRIMARY KEY (user_id, role_id)
);
```

---

## ツリー構造の誤った表現

### 問題のある設計（隣接リストモデル）

```sql
CREATE TABLE categories (
  category_id INT PRIMARY KEY,
  name VARCHAR(100),
  parent_id INT REFERENCES categories  -- 自己参照
);
```

隣接リストモデル自体は悪くないが、**全階層の取得に再帰クエリ（WITH RECURSIVE）が必要**。

### 用途別の選択肢

| モデル | 読み取り | 書き込み | 向いている用途 |
|---|---|---|---|
| 隣接リスト | 再帰が必要 | 簡単 | 階層が浅い・更新が多い |
| 経路列挙（パスカラム） | LIKE で可能 | パス更新が必要 | 読み取り優位・深さ不定 |
| 入れ子集合 | 範囲クエリで高速 | 挿入コストが高い | 読み取り専用ツリー |
| 閉包テーブル | 高速・柔軟 | テーブルが大きくなる | 高頻度な階層クエリ |

---

## ダブルミーニング列

### 問題のある設計

```sql
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  status VARCHAR(20),
  -- status = 'cancelled' の時のみ cancel_reason を使う
  -- status = 'shipped' の時のみ tracking_number を使う
  extra_info TEXT  -- 文脈によって意味が変わる
);
```

### なぜ問題か

- 列の意味がステータスに依存して変わる
- アプリ側でのバリデーションが複雑
- ドキュメントなしでは解読不能

### 改善案

```sql
CREATE TABLE orders (order_id INT PRIMARY KEY, status VARCHAR(20));
CREATE TABLE order_cancellations (order_id INT REFERENCES orders, reason TEXT);
CREATE TABLE order_shipments (order_id INT REFERENCES orders, tracking_number VARCHAR(50));
```

---

## NULL の乱用

### 問題のある設計

```sql
-- NULL が「データなし」「未設定」「N/A」「0」の代わりに使われている
CREATE TABLE employees (
  employee_id INT PRIMARY KEY,
  salary DECIMAL(10,2),       -- 役員は NULL？ 0？
  manager_id INT,             -- トップは NULL（許容）
  department_id INT,          -- 未配属は NULL？ 専用部署？
  retired_at TIMESTAMP        -- 在職中は NULL（許容）
);
```

### NULL を使っていい場合

- **値が本当に不明・存在しない**（例：`retired_at` — 在職中は退職日がない）
- 自己参照の最上位（ルートノードの `parent_id`）

### NULL を避けるべき場合

- 「まだ入力されていない」→ デフォルト値や別テーブルで管理
- 「この区分には該当しない」→ スキーマで表現
- 計算に使う数値列（NULL の算術演算は NULL になる）

---

## 浮動小数点で金額を扱う

### 問題のある設計

```sql
price FLOAT  -- または DOUBLE
```

### なぜ問題か

- `0.1 + 0.2 = 0.30000000000000004`（IEEE 754の誤差）
- 金額の合計が丸め誤差で一致しない

### 改善案

```sql
price DECIMAL(10, 2)  -- 整数10桁、小数2桁
-- または金額を「円」「セント」など最小通貨単位の整数で保持
price_cents BIGINT
```

---

## 過剰インデックス・インデックス不足

### 過剰インデックスの問題

- 書き込み（INSERT/UPDATE/DELETE）のたびにインデックスも更新 → 遅くなる
- ストレージを消費する
- クエリオプティマイザが混乱する場合がある

### インデックス不足の問題

- WHERE 句・JOIN 条件のフルスキャンが発生
- テーブルが大きくなると致命的に遅くなる

### インデックスを貼るべき列

1. 主キー（自動）
2. 外部キー（JOINで使う）
3. WHERE 句で頻繁に使われる列（特に選択性が高い列）
4. ORDER BY / GROUP BY に使う列
5. 複合インデックスは「等値条件→範囲条件」の順に設計

→ 詳細は `references/physical-design.md` を参照。
