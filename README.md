# dotfiles

macOS 用の個人設定ファイル管理リポジトリ。

![開発環境](assets/dev-environment.png)
*Ghostty + Zellij 上で AstroNvim と Claude Code を使った開発環境*

シェル、エディタ、ターミナル等の設定をシンボリックリンクで管理する。`~/dotfiles/` に clone して使用。

## 技術スタック

| カテゴリ | ツール | 説明 |
|----------|--------|------|
| OS | macOS | Intel / Apple Silicon 両対応 |
| パッケージ管理 | Homebrew | macOS 用パッケージマネージャ |
| | mise | ランタイムバージョン管理（Python 等） |
| | uv | 高速な Python パッケージマネージャ |
| シェル | zsh | デフォルトシェル |
| | Starship | カスタマイズ可能なプロンプト |
| ターミナル | Ghostty | ターミナルエミュレータ |
| | Zellij | ターミナルマルチプレクサ（tmux 代替） |
| 開発ツール | Neovim（AstroNvim ベース） | エディタ |
| | Claude Code | コーディングエージェント |
| ユーティリティ | Raycast | ランチャーアプリ |

## ディレクトリ構成

```
.
├── .zprofile              # ログインシェル設定
├── .zshrc                 # インタラクティブシェル設定
├── Brewfile               # Homebrew パッケージ
├── setup.sh               # セットアップスクリプト
├── macos.sh               # macOS 設定用スクリプト
│
├── .config/               # ~/.config/ にリンク
│   ├── ghostty/           # ターミナル設定
│   ├── nvim/              # Neovim 設定
│   ├── mise/              # ランタイム管理設定
│   ├── raycast/           # Raycast スクリプト
│   ├── starship.toml      # プロンプト設定
│   ├── uv/                # Python パッケージ管理設定
│   └── zellij/            # ターミナルマルチプレクサ設定
│
└── .claude/               # ~/.claude/ にリンク（ユーザーレベル設定）
    ├── CLAUDE.md          # カスタム指示
    ├── settings.json      # 設定
    └── skills/            # カスタムスキル
```

詳細は各ディレクトリの README を参照。

## セットアップ

### 前提条件

- macOS（Intel / Apple Silicon 両対応）
- zsh（macOS デフォルト）
- Git
- Xcode Command Line Tools

### インストール

```bash
git clone https://github.com/Imutaakihiro/dotfiles.git ~/dotfiles
~/dotfiles/setup.sh
source ~/.zshrc  # またはターミナル再起動
```

> [!WARNING]
> - 既存の設定ファイル（.zshrc, .zprofile, .config/nvim 等）は上書きされる。必要に応じて事前にバックアップを取ること
> - Homebrew のインストール時に sudo パスワードを求められる場合がある

### setup.sh の内容

1. Homebrew をインストール（未インストールの場合）
2. Brewfile のパッケージをインストール
3. mise で Python をインストール
4. uv をインストール
5. uv-tools.txt に記載されたツールをインストール
6. Claude Code をインストール（未インストールの場合）
7. Google Cloud SDK をインストール（未インストールの場合）
8. シンボリックリンクを作成

## カスタムコマンド

`.zshrc` で定義しているシェル関数。

| コマンド | 説明 |
|----------|------|
| `ztmp [dir]` | 指定ディレクトリで Nvim + Claude Code の Zellij タブを開く（省略時はカレントディレクトリ） |

## macOS システム設定

`defaults` コマンドで macOS の設定を適用する。setup.sh とは独立しており、必要に応じて手動実行する。

### 使い方

```bash
~/dotfiles/macos.sh
```

> [!WARNING]
> - システムフォルダの英語表示に sudo パスワードが必要
> - 設定反映のため、実行後に再ログインまたは再起動を推奨

### macos.sh の内容

- **Dock**: 右側配置、自動非表示、アイコンサイズ、アニメーション速度
- **Finder**: 隠しファイル表示、拡張子表示、パスバー、ステータスバー、カラム表示、フォルダ優先
- **キーボード**: キーリピート速度（超速）、長押しでキーリピート
- **テキスト入力**: 自動大文字・スペル修正・スマート引用符などを無効化
- **トラックパッド**: タップでクリック、3本指ドラッグ、ナチュラルスクロール
- **マウス**: スクロール速度
- **Hot Corners**: 左下でスクリーンセーバー
- **メニューバー**: バッテリー%表示、Bluetooth表示
- **スクリーンショット**: ~/Pictures/Screenshots に保存
- **TextEdit**: デフォルトをプレーンテキストに
- **その他**: .DS_Store をネットワーク/USB に作成しない、フォルダ名を英語表示

## Vim 学習メモ

### モード

Vim には「モード」という概念がある。普通のエディタと違い、キー入力の意味がモードによって変わる。

| モード | 役割 | 入り方 |
|--------|------|--------|
| **Normal** | 移動・操作 | `Esc` |
| **Insert** | 文字を入力する | `i` |
| **Visual** | 範囲選択 | `v` |

Vim を開いた瞬間は **Normal モード**。文字を打つには `i` → Insert モードに入ってから入力。打ち終わったら `Esc` で Normal モードに戻る。

### 基本移動

Normal モードでの移動。ホームポジションから手を動かさなくていいのが強み。

| キー | 動作 |
|------|------|
| `h` | 左 |
| `j` | 下 |
| `k` | 上 |
| `l` | 右 |
| `w` | 次の単語の先頭へ |
| `b` | 前の単語の先頭へ |
| `0` | 行の先頭へ |
| `$` | 行の末尾へ |
| `gg` | ファイルの先頭へ |
| `G` | ファイルの末尾へ |

### 編集操作

編集コマンドは **動詞 + 名詞** の組み合わせ。

| キー | 動作 |
|------|------|
| `x` | カーソルの文字を削除 |
| `dd` | 行を丸ごと削除（切り取り） |
| `yy` | 行を丸ごとコピー |
| `p` | 貼り付け（カーソルの後） |
| `u` | アンドゥ |
| `Ctrl r` | リドゥ |

動詞（`d` 削除 / `y` コピー / `c` 変更）と移動を組み合わせる：

| キー | 動作 |
|------|------|
| `dw` | 次の単語を削除 |
| `d$` | 行末まで削除 |
| `cw` | 次の単語を変更（Insert モードへ） |

---

## 手動インストールアプリ

Homebrew で管理できないアプリ。

| アプリ | 入手先 | 説明 |
|--------|--------|------|
| RunCat | [App Store](https://apps.apple.com/jp/app/runcat/id1429033973) | メニューバーでCPU使用率を表示 |
