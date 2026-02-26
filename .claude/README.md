# .claude

Claude Code のユーザーレベル設定。`~/.claude/` にシンボリックリンクされる。

## ディレクトリ構成

```
.claude/
├── CLAUDE.md          # カスタム指示（プライベート）
├── settings.json      # Claude Code 設定
├── statusline.sh      # ステータスライン表示スクリプト
├── scripts/           # ステータスライン等で使用するスクリプト
│   └── fetch_usage.sh # API 使用量取得
├── sounds/            # 通知音
│   ├── complete.wav   # タスク完了時
│   └── confirm.wav    # 確認要求時
└── skills/            # カスタムスキル
    ├── agent-creator/
    ├── claude-md/
    ├── doc-coauthoring/
    ├── git-cleanup/
    ├── grok-search/
    ├── internal-comms/
    ├── skill-creator/
    └── structured-workflow/
```

## ファイル説明

### CLAUDE.md

Claude Code へのカスタム指示を記述するファイル。ユーザーの好みや作業ルールを定義する。

### settings.json

Claude Code の動作設定。主な項目：

| 項目 | 説明 |
|------|------|
| `permissions.allow` | 自動許可するコマンド |
| `permissions.deny` | 拒否するコマンド |
| `hooks` | イベント発生時に実行するコマンド |
| `statusLine` | ステータスライン表示の設定 |

### skills/

カスタムスキル（`/スキル名` で呼び出せる拡張機能）を格納するディレクトリ。作成方法は[公式ドキュメント](https://code.claude.com/docs/en/skills)を参照。

| スキル | 説明 | 提供元 |
|--------|------|--------|
| agent-creator | サブエージェントの作成・改善ガイド | 自作 |
| claude-md | CLAUDE.md の作成・改善支援 | 自作 |
| [doc-coauthoring](https://github.com/anthropics/skills/tree/main/skills/doc-coauthoring) | ドキュメント共同作成ワークフロー | Anthropic 公式 |
| git-cleanup | マージ済みブランチの整理 | 自作 |
| [grok-search](skills/grok-search/README.md) | Grok API で X の投稿を検索・要約 | 自作 |
| [internal-comms](https://github.com/anthropics/skills/tree/main/skills/internal-comms) | 社内コミュニケーション文書の作成 | Anthropic 公式 |
| [skill-creator](https://github.com/anthropics/skills/tree/main/skills/skill-creator) | スキルの作成ガイド | Anthropic 公式 |
| structured-workflow | リサーチ・計画・実装の構造化ワークフロー | 自作 |

## カスタマイズ

### 通知音の変更

`sounds/` 内の `.wav` ファイルを差し替える。ファイル名は維持すること。

### ステータスラインの変更

`statusline.sh` を編集する。スクリプトは標準入力から JSON を受け取り、標準出力に表示内容を出力する。

### コマンド許可の追加

`settings.json` の `permissions.allow` に追加：

```json
"Bash(コマンド:*)"
```

### フックの追加

`settings.json` の `hooks` にイベントとコマンドを追加。利用可能なイベント：

- `Stop` - タスク完了時
- `PermissionRequest` - 確認要求時
