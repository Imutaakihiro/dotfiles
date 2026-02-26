# サブエージェント YAML 仕様

サブエージェント定義ファイルは `.claude/agents/<name>.md` に配置する。

## 基本構造

```yaml
---
name: agent-name
description: エージェントの説明（トリガー条件含む）
---

# エージェント名

プロンプト本文（エージェントへの指示）
```

## 必須フィールド

### name
エージェントの識別子。ケバブケース推奨。

```yaml
name: code-reviewer
name: db-query-runner
```

### description
エージェントの説明。Claude が委譲判断に使用する。

**含めるべき情報:**
1. 何をするか
2. いつ使うか
3. 何を返すか

```yaml
description: コード品質・セキュリティを専門レビュー。PR作成前やコード変更後に使用。具体的な修正案を提示。
```

## オプションフィールド

### tools
許可するツールのリスト。未指定時は全ツール許可。

```yaml
tools: Read, Grep, Glob, Bash
```

### disallowedTools
禁止するツールのリスト。tools と併用可能。

```yaml
disallowedTools: Write, Edit, NotebookEdit
```

### model
使用するモデル。未指定時はメイン会話から継承。

```yaml
model: haiku   # 高速・低コスト
model: sonnet  # バランス型
model: opus    # 高精度・高コスト
```

### skills
エージェントに注入するスキルのリスト。

```yaml
skills:
  - coding-conventions
  - error-handling
```

### allowedPrompts
許可するプロンプトベースの操作。

```yaml
allowedPrompts:
  - tool: Bash
    prompt: run tests
  - tool: Bash
    prompt: install dependencies
```

## スキル連携フィールド（SKILL.md 用）

### context
スキルの実行コンテキスト。

```yaml
context: fork  # サブエージェントとして隔離実行
```

### agent
`context: fork` 時のエージェントタイプ。

```yaml
agent: Explore        # 探索用（読み取り専用）
agent: general-purpose # 汎用
```

## 配置場所

| 場所 | スコープ |
|------|----------|
| `~/.claude/agents/` | ユーザーレベル（全プロジェクト共通） |
| `.claude/agents/` | プロジェクトレベル（リポジトリ固有） |

## 完全な例

```yaml
---
name: code-reviewer
description: コード品質・セキュリティ・保守性を専門レビュー。PR作成前、コード変更後に使用。OWASP Top 10、可読性、テストカバレッジをチェックし、具体的な修正案を提示。
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
model: sonnet
---

# Code Reviewer

シニアコードレビュアーとして以下をチェックする：

## チェック項目

1. **コード品質**
   - 可読性と命名規則
   - 関数・クラスの責務分離
   - 重複コードの有無

2. **セキュリティ**
   - OWASP Top 10 脆弱性
   - 入力バリデーション
   - 機密情報の露出

3. **保守性**
   - テストカバレッジ
   - ドキュメント
   - エラーハンドリング

## 出力形式

問題ごとに以下を記載：
- 問題の概要
- 該当箇所（ファイル:行番号）
- 具体的な修正案
```
