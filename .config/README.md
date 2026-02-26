# .config

各種アプリケーションの設定ファイル。`~/.config/` にシンボリックリンクされる。

セットアップ方法は [親ディレクトリの README](../README.md) を参照。

## ディレクトリ構成

```
.config/
├── ghostty/           # ターミナルエミュレータ
├── git/               # Git グローバル設定
├── mise/              # ランタイムバージョン管理
├── nvim/              # エディタ（詳細は nvim/README.md）
├── raycast/           # ランチャー
├── starship.toml      # シェルプロンプト
├── uv/                # Python パッケージ管理
└── zellij/            # ターミナルマルチプレクサ
```

## [Ghostty](https://ghostty.org/)

GPU ベースの高速ターミナルエミュレータ。macOS / Linux 対応。

### ファイル構成

| ファイル | 説明 |
|----------|------|
| `config` | 設定ファイル |
| `bg.jpg` | 背景画像 |

### 主な設定

| カテゴリ | 設定内容 |
|----------|----------|
| テーマ | GitHub Dark |
| フォント | HackGen35 Console（14pt） |
| 背景 | 画像付き（透過度 7%）、ぼかし効果 |
| ウィンドウ | フルスクリーン起動、パディング 16px |
| カーソル | ブロック型、点滅なし |
| キーバインド | 左 Option キーを Alt として使用（macOS の Option は通常特殊文字入力だが、Zellij のキーバインドで Alt として使うため） |

## Git

グローバル gitignore の設定。全リポジトリ共通で機密情報の誤コミット防止、OS/エディタの不要ファイル除外をガードレールとして提供する。

### ファイル構成

| ファイル | 説明 |
|----------|------|
| `ignore` | グローバル gitignore（`~/.config/git/ignore` に配置すると Git が自動認識） |

### 除外対象

| カテゴリ | パターン例 |
|----------|------------|
| 機密情報 | `.env`, `*.pem`, `*.key`, `credentials.json`, `service-account*.json` |
| OS 生成ファイル | `.DS_Store`, `Thumbs.db` |
| エディタ | `*.swp`, `*.swo`, `*~` |
| 一時ファイル | `tmp/` |

## [mise](https://mise.jdx.dev/)

プログラミング言語のバージョン管理ツール。asdf の Rust 製代替で高速。グローバルにインストールする言語を管理する（プロジェクト単位の Python 管理は uv を使用）。

### 設定内容

| 項目 | 値 |
|------|-----|
| Python | 3.13 |

## [Neovim](https://neovim.io/)

Vim ベースの高機能テキストエディタ。[AstroNvim](https://astronvim.com/) をベースにカスタマイズ。

詳細は [nvim/README.md](nvim/README.md) を参照。

## [Raycast](https://www.raycast.com/)

macOS 用ランチャーアプリ。Spotlight の高機能版で、カスタムスクリプトやワークフローを実行できる。

> [!NOTE]
> このディレクトリには個人用のスクリプトコマンドのみ格納しており、他の人には不要な場合が多い。

### スクリプトコマンド

| ファイル | 説明 |
|----------|------|
| `delete-screenshot.sh` | スクリーンショットを削除 |
| `open-marimo.sh` | marimo（Python ノートブック）を起動 |
| `zettel-id.sh` | Zettelkasten 用の ID を生成 |

## [Starship](https://starship.rs/)

シェルプロンプトのカスタマイズツール。Rust 製で高速。Git ブランチ、言語バージョンなどをプロンプトに表示できる。

### 設定内容

デフォルト設定を使用。カスタマイズする場合は [公式ドキュメント](https://starship.rs/config/) を参照。

## [uv](https://docs.astral.sh/uv/)

高速な Python パッケージマネージャ。pip / venv の代替として使用。Rust 製で pip より 10〜100 倍速い。

### 設定内容

| 項目 | 値 | 説明 |
|------|-----|------|
| `python-preference` | `only-managed` | mise で管理された Python のみ使用 |

## [Zellij](https://zellij.dev/)

ターミナルマルチプレクサ。tmux の代替で、ペイン分割やセッション管理ができる。Rust 製でモダンな UI。

### ファイル構成

| ファイル | 説明 |
|----------|------|
| `config.kdl` | メイン設定（テーマ、キーバインド） |
| `layouts/default.kdl` | デフォルトレイアウト |

### 主な設定

| カテゴリ | 設定内容 |
|----------|----------|
| テーマ | カスタム（Tokyo Night 風カラー） |
| キーバインド | Vim 風（hjkl 移動）+ tmux 互換モード（Ctrl+b） |
| 終了時の動作 | セッションを終了（デタッチではなく quit） |

### デフォルトレイアウト

開発用の2ペインレイアウト：

```
┌───────────────────┬────────────────┐
│                   │                │
│      NeoVim       │   Claude Code  │
│      (65%)        │     (35%)      │
│                   │                │
└───────────────────┴────────────────┘
```

プロジェクトごとにタブが用意されており、Zellij 起動時に自動で開く。

> [!NOTE]
> `layouts/default.kdl` のタブ設定は個人用リポジトリを指定しているため、利用時は自分のプロジェクトに合わせて編集すること。

### 自動起動

`.zshrc` で Ghostty 起動時に Zellij が自動起動するよう設定している。詳細は `.zshrc` を参照。
