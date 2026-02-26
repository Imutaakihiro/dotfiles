---
name: claude-md
description: CLAUDE.md ファイルの作成・改善を支援。新規プロジェクトの CLAUDE.md 作成、既存ファイルのベストプラクティスに基づく改善を行う。「CLAUDE.md を作りたい」「CLAUDE.md をレビューして」などのリクエストで使用。
---

# CLAUDE.md 作成・改善

## ワークフロー

### 新規作成

1. プロジェクト構造を確認（ls、README.md、package.json 等）
2. 技術スタックを特定
3. WHAT/HOW の構成で CLAUDE.md を作成
4. ユーザーに確認

### 既存ファイルの改善

1. 現在の CLAUDE.md を読み込む
2. `references/best-practices.md` のチェックリストで評価
3. 改善点を提案
4. ユーザー承認後に修正

## 出力ルール

- **行数**: 60行以下を目指す（最大300行）
- **構成**: WHAT（技術・構造）→ HOW（作業方法）
- **言語**: プロジェクトの主要言語に合わせる

## 参照

詳細なベストプラクティス: [references/best-practices.md](references/best-practices.md)
