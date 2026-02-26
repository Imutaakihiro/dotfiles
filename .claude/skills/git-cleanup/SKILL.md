---
name: git-cleanup
description: GitHub PR マージ後のローカル Git リポジトリをクリーンアップ。マージ済みブランチの削除、リモート同期、main ブランチへの切り替えを実行。「/git-cleanup」「マージ後の掃除」「ブランチ整理」で使用。
---

# Git Cleanup

マージ後のローカルリポジトリを整理する。

## ワークフロー

以下の順序で実行する:

1. **リモート同期**: `git fetch --prune` で最新情報を取得し、リモートで既に削除されたブランチの追跡参照（origin/xxx）をローカルから削除
2. **main に切り替え**: `git checkout main`
3. **main を最新化**: `git pull`
4. **マージ済みブランチを削除**: main にマージ済みのローカルブランチを削除

## マージ済みブランチの削除

```bash
git branch --merged main | grep -v '^\*\|main' | xargs -r git branch -d
```

- `--merged main`: main にマージ済みのブランチのみ
- `-d`: 安全な削除（マージ済みのみ削除可能）
- main 自体と現在のブランチ（`*`）は除外

## 出力

各ステップの実行結果を表示し、削除したブランチがあれば一覧を報告する。
