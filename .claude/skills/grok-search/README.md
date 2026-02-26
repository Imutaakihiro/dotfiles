# Grok Search

xAI の Grok API（x_search ツール）を使い、X (Twitter) の投稿を Claude Code から検索・要約するスキル。

Claude Code 単体では X の投稿を直接検索できないため、Grok API を経由する。自然言語でクエリを送ると、Grok モデルが X を検索し、結果を要約・引用付きで返す。

Claude Code 内で `/grok-search` または「X を検索して」で呼び出せる。

## インストール

このスキルは [dotfiles リポジトリ](https://github.com/tanuuuuuuu/dotfiles) に含まれている。dotfiles のセットアップ後、シンボリックリンク経由で `~/.claude/skills/grok-search/` に配置される。

個別にスキルだけ使いたい場合は、`grok-search/` ディレクトリを `~/.claude/skills/` にコピーする。

## 前提条件

- macOS（`security` コマンドでキーチェーンにアクセスするため）
- Claude Code（スキル機能を使うため）
- [xAI アカウント](https://console.x.ai)（API キー発行に必要）

## セットアップ

### 1. xAI アカウント作成・API キー発行

1. [xAI コンソール](https://console.x.ai) でアカウントを作成
2. [API Keys](https://console.x.ai/team/default/api-keys) ページで新しいキーを作成

キー作成時の推奨設定:

| 項目 | 推奨値 | 理由 |
|---|---|---|
| Name | `xai-grok-cli` | 用途が一目でわかる命名 |
| Model | `grok-4-1-fast-reasoning` を含む | 最安モデル、x_search 対応 |
| Endpoint | `/v1/responses` を含む | x_search に必要 |
| RPM | `10` | CLI 手動利用に十分。暴走防止 |
| TPM | `10000` | 無料枠を一瞬で溶かさない安全策 |

### 2. クレジットの購入

API 利用にはクレジットの事前購入が必要（サブスクリプションではなくプリペイド方式）。コンソールの [Billing](https://console.x.ai) ページでクレジットカードを登録し、クレジットを購入する。`doesn't have any credits` エラーが出たら残高を確認する。

### 3. API キーをキーチェーンに登録

API キーはリポジトリにコミットせず、macOS キーチェーンで管理する。

```bash
security add-generic-password -s "Grok-API-Key" -a "grok" -w "your-api-key"
```

登録を確認（先頭10文字のみ表示）:

```bash
security find-generic-password -s "Grok-API-Key" -w | head -c 10
```

既にエントリが存在する場合はエラーになる。キーを更新するには、削除してから再登録する:

```bash
security delete-generic-password -s "Grok-API-Key"
security add-generic-password -s "Grok-API-Key" -a "grok" -w "new-api-key"
```

スクリプトはキーチェーンのサービス名 `Grok-API-Key` を参照する。この名前を変更するとスクリプトが動作しなくなるので注意。

### 4. 動作確認

```bash
bash ~/.claude/skills/grok-search/scripts/search.sh "テスト検索"
```

JSON レスポンスが返れば成功。Claude Code 内では `/grok-search` または「X を検索して」で呼び出せる。

## 使い方

Claude Code 内で `/grok-search` に続けて検索したい内容を入力する。

### 基本検索

```
/grok-search dbt の最新動向
```

### ユーザー指定検索

特定の X アカウントに絞って検索できる。

```
/grok-search Elon Musk の AI に関する発言 {"handles":["elonmusk"]}
```

### 期間指定検索

日付範囲を指定して検索できる。

```
/grok-search dbt リリース情報 {"from":"2026-01-01","to":"2026-02-14"}
```

### オプション一覧

第2引数の JSON で以下のフィルタを指定可能:

| キー | 説明 | 例 |
|---|---|---|
| `handles` | 対象ユーザー（`@` なし、最大10） | `["elonmusk"]` |
| `from` | 検索開始日 (YYYY-MM-DD) | `"2026-01-01"` |
| `to` | 検索終了日 (YYYY-MM-DD) | `"2026-02-14"` |

## コスト

プリペイド方式。事前にクレジットを購入して利用する。

### 料金内訳

| 項目 | 料金 |
|---|---|
| x_search ツール呼び出し | $5 / 1,000回 |
| モデル入力トークン（grok-4-1-fast-reasoning） | $0.20 / 100万トークン |
| モデル出力トークン | $0.50 / 100万トークン |

### 1回あたりの概算

Grok モデルは1回のクエリで x_search を内部的に **複数回** 呼び出す。呼び出し回数はクエリの複雑さにより変動する（実測: 1〜11回）。

実測値:

| クエリ例 | x_search 回数 | 概算コスト |
|---|---|---|
| 単純な検索 | 1〜4回 | $0.01〜0.03 |
| 複雑な検索（「dbt の最新動向」） | 11回 | 約 $0.06 |

$25 のクレジットで **数百〜数千回** の検索が目安（クエリの複雑さによる）。

最新の料金は [xAI Models and Pricing](https://docs.x.ai/developers/models) を参照。

## カスタマイズ

### 自分の X アカウント

`SKILL.md` の「ユーザー情報」セクションに自分の X アカウントが設定されている。フォークした場合は自分のアカウントに変更する。

```yaml
## ユーザー情報

- X アカウント: `tanuhack`  ← ここを自分のアカウントに変更
```

これにより「自分の投稿を要約して」のような指示が正しく動作する。

### モデル変更

`scripts/search.sh` 内の `model` パラメータを変更する。

```bash
# 変更前
model: "grok-4-1-fast-reasoning",

# 変更後（例）
model: "grok-3",
```

API キーにモデル制限をかけている場合は、[API Keys](https://console.x.ai/team/default/api-keys) ページで対象モデルの許可も必要。