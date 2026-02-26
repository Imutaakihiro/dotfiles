# dotfiles

macOS 用の個人設定ファイル管理リポジトリ。

## 技術スタック

- OS: macOS
- シェル: zsh
- パッケージ管理: Homebrew
- ランタイム管理: mise
- Python パッケージ管理: uv
- エディタ: Neovim
- プロンプト: Starship
- ターミナルマルチプレクサ: Zellij
- ターミナルエミュレータ: Ghostty
- ランチャー: Raycast
- コーディングエージェント: Claude Code

## 構造

- `.zprofile` - ログインシェル設定
- `.zshrc` - インタラクティブシェル設定
- `Brewfile` - Homebrew パッケージ一覧
- `.config/` - 各種ツールの設定
- `.claude/` - Claude Code の設定（スキル含む）
- `setup.sh` - 初期セットアップスクリプト
- `macos.sh` - macOS システム設定（defaults コマンド）

## リポジトリ配置

- ローカルリポジトリは `~/repos/` で管理
- dotfiles のみ例外として `~/dotfiles/` に配置（慣習的にわかりやすいため）

## 作業ルール

- シンボリックリンクで管理されるファイルは直接編集しない
- ディレクトリ構造を変更した場合は CLAUDE.md と README.md の整合性を確認・更新する
- `.config/` および `.claude/` 以下はミラーリング方式（実際の配置場所と同じ構造）で管理する
- `.claude/` はユーザーレベル設定として `~/.claude/` にリンクされるため、このプロジェクト固有の Claude Code 設定は作成できない（必要になった場合は構造の見直しが必要）
- コミット前に機密情報（APIキー、トークン等）が含まれていないか確認する
