---
name: grok-search
description: Grok API の x_search ツールで X (Twitter) の投稿を検索・要約。「/grok-search」「X を検索」「X の投稿を調べて」「Twitter で検索」「X でのトレンド」で使用。
---

# Grok Search

xAI の Grok API（x_search ツール）を使い、X の投稿を検索して結果を要約する。

## ユーザー情報

- X アカウント: `tanuhack`
- 「自分の投稿」「自分のポスト」などの指示があった場合は `{"handles":["tanuhack"]}` を使う

## ワークフロー

1. ユーザーの検索意図からクエリとオプションを決定
2. `scripts/search.sh` を実行
3. レスポンス JSON からテキスト部分を抽出して要約を報告

### 基本検索

```bash
bash ~/.claude/skills/grok-search/scripts/search.sh "検索クエリ"
```

### オプション付き検索

第2引数に JSON でフィルタを指定可能:

```bash
bash ~/.claude/skills/grok-search/scripts/search.sh "検索クエリ" '{"handles":["user1","user2"],"from":"2026-01-01","to":"2026-02-14"}'
```

| キー | 説明 | 例 |
|---|---|---|
| `handles` | 対象ユーザー（最大10） | `["elonmusk"]` |
| `from` | 検索開始日 (YYYY-MM-DD) | `"2026-01-01"` |
| `to` | 検索終了日 (YYYY-MM-DD) | `"2026-02-14"` |

## レスポンス処理

API レスポンスは JSON で返る。`output` 配列内の `type: "message"` から `content[].text` を抽出して報告する。引用 URL があれば併記する。

## エラー時

- `error` キーがある場合はそのメッセージをユーザーに伝える
- クレジット不足: xAI コンソールでの確認を案内
- キーチェーン未登録: `security add-generic-password` コマンドを案内

## 注意事項

- macOS 専用（`security` コマンドでキーチェーンにアクセス）
- x_search は 1,000回 / $5 のコスト。無駄な連続呼び出しを避ける
- モデル: `grok-4-1-fast-reasoning`（スクリプト内で固定）
