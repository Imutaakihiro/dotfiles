# [Neovim](https://neovim.io/)

[AstroNvim](https://astronvim.com/) v5 をベースにした Neovim 設定。

## 概要

Vim 初心者がゼロから設定を構築するのは大変なため、オールインワンのディストリビューション（プラグインや設定があらかじめ組み込まれた配布パッケージ）である AstroNvim をベースに、必要な部分だけカスタマイズする方針を採用。IDE 風の機能（ファイルツリー、LSP、Git 連携など）が最初から揃っており、追加設定の学習コストを抑えられる。

### 前提条件

| 項目 | 要件 |
|------|------|
| Neovim | v0.9.0 以上 |
| フォント | Nerd Font 対応フォント（ファイルアイコン等の表示に必要。[Nerd Fonts](https://www.nerdfonts.com/) 参照） |
| Git | プラグイン管理に必要 |

### プラグイン管理

[lazy.nvim](https://github.com/folke/lazy.nvim) で管理。AstroNvim が内部で採用しており、起動時に自動でブートストラップされる。

### 参考リンク

- [AstroNvim ドキュメント](https://docs.astronvim.com/) - 設定方法の詳細
- [AstroNvim GitHub](https://github.com/AstroNvim/AstroNvim) - ソースコード

## ファイル構成

```
nvim/
├── init.lua              # エントリーポイント
├── lazy-lock.json        # プラグインバージョンのロックファイル
├── lua/
│   ├── lazy_setup.lua    # lazy.nvim 設定
│   ├── community.lua     # AstroCommunity プラグイン（未使用）
│   ├── polish.lua        # 最終処理（未使用）
│   └── plugins/          # カスタムプラグイン設定
│       ├── astrocore.lua   # コア設定（オプション、autocmd）
│       ├── astrolsp.lua    # LSP 設定（未使用）
│       ├── astroui.lua     # UI 設定（カラースキーム、透明化）
│       ├── bufferline.lua  # バッファタブ表示
│       ├── gitsigns.lua    # Git 差分・blame 表示
│       ├── iceberg.lua     # カラースキーム追加
│       ├── im-select.lua   # IME 自動切替
│       ├── lualine.lua     # ステータスライン（モード表示）
│       ├── mason.lua       # LSP/ツール管理（未使用）
│       ├── neo-tree.lua    # ファイルツリー
│       ├── none-ls.lua     # フォーマッタ/リンター（未使用）
│       ├── treesitter.lua  # シンタックスハイライト（未使用）
│       └── user.lua        # サンプル設定（未使用）
├── .luarc.json           # Lua LSP 設定
├── .neoconf.json         # neoconf 設定
├── .stylua.toml          # StyLua フォーマッタ設定
├── selene.toml           # Selene リンター設定
└── neovim.yml            # Selene 用 vim グローバル定義
```

> [!NOTE]
> 「未使用」と記載のファイルは AstroNvim テンプレートのサンプル。必要に応じて有効化できる（詳細は「テンプレートファイルについて」を参照）。

## 主なカスタマイズ

### 基本設定

| カテゴリ | 設定内容 | 理由 |
|----------|----------|------|
| Leader キー | Space | AstroNvim デフォルト。押しやすく、多くのキーマップで使用 |
| カラースキーム | github_dark_default | GitHub の見慣れた配色。Ghostty と統一感を出すため |
| 背景 | 透明化 | Ghostty のぼかし効果を透過させるため |

### エディタ動作

| カテゴリ | 設定内容 | 理由 |
|----------|----------|------|
| 行の折り返し | 有効（単語境界で折り返し） | 長い行を横スクロールせずに読めるようにするため |
| カーソルライン | アクティブウィンドウのみ表示 | 複数ウィンドウ時にどこにいるか視認しやすくするため |

### プラグイン

| プラグイン | 種別 | 設定内容 | 理由 |
|------------|------|----------|------|
| gitsigns | 標準 | インライン blame 表示 | 各行の変更者・日時を即座に確認できる（GitLens 風） |
| Neo-tree | 標準 | 起動時に自動フォーカス | IDE 風にファイルツリーをすぐ使えるようにするため |
| bufferline | 追加 | バッファをタブ風に表示 | 複数ファイル編集時にバッファを視覚的に管理しやすくするため |
| im-select | 追加 | Insert モードを抜けたとき IME を英語に切替 | Normal モードに戻ったとき日本語入力が残る問題を解消 |
| lualine | 追加 | モード表示付きステータスライン | 現在のモード（Normal/Insert/Visual 等）を色付きで表示 |

> [!NOTE]
> **種別**: 標準 = AstroNvim プリインストール（設定カスタマイズ）、追加 = 後から追加したプラグイン

## プラグイン設定

### astrocore.lua - コア設定

AstroNvim のコア機能をカスタマイズ。

| 設定 | 値 | 説明 |
|------|-----|------|
| `wrap` | true | 行の折り返しを有効化 |
| `linebreak` | true | 単語の途中で折り返さない |
| `breakindent` | true | 折り返し行もインデントを維持 |
| `cursorline` | true | カーソルラインを表示 |

**autocmd**: アクティブウィンドウのみカーソルラインを表示。ウィンドウに入ったとき（`WinEnter`）にオン、離れたとき（`WinLeave`）にオフに切り替え。

### astroui.lua - UI 設定

| 設定 | 値 | 説明 |
|------|-----|------|
| カラースキーム | `github_dark_default` | GitHub Dark テーマ |
| 背景透明化 | 複数のハイライトグループで `bg = "NONE"` | Ghostty の背景ぼかし効果を透過 |

**透明化対象**: Normal, NormalNC, NormalFloat, SignColumn, LineNr, Neo-tree 関連など。

### bufferline.lua - バッファタブ

[bufferline.nvim](https://github.com/akinsho/bufferline.nvim) でバッファをタブ風に表示。AstroNvim デフォルトの Heirline tabline を無効化して置き換え。

| 設定 | 値 | 説明 |
|------|-----|------|
| モード | buffers | バッファをタブとして表示 |
| 診断表示 | nvim_lsp | LSP のエラー・警告をタブに表示 |
| Neo-tree 連携 | オフセット設定 | ファイルツリーの横にタブを表示 |
| 背景 | 透明化 + アクティブタブのみ背景色 | 選択中のバッファを視認しやすく |

### gitsigns.lua - Git 連携

[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) で Git の差分表示とインライン blame を実現。

| 設定 | 値 | 説明 |
|------|-----|------|
| `current_line_blame` | true | カーソル行の blame を表示 |
| `virt_text_pos` | eol | 行末に表示 |
| `delay` | 300ms | 表示までの遅延 |
| フォーマット | `<author>, <date> - <summary>` | 作者、日付、コミットメッセージを表示 |

### iceberg.lua - カラースキーム

追加のカラースキームを遅延読み込みで登録。

| カラースキーム | 説明 |
|----------------|------|
| iceberg | 青を基調としたクールな配色 |
| molokai | Sublime Text 風の配色 |
| gruvbox | レトロな暖色系配色 |
| github-nvim-theme | GitHub の配色（現在使用中） |

### im-select.lua - IME 自動切替

[im-select.nvim](https://github.com/keaising/im-select.nvim) で Normal モード移行時に IME を自動で英語に切り替え。

| 設定 | 値 | 説明 |
|------|-----|------|
| `default_im_select` | com.apple.keylayout.ABC | 英語キーボード |
| `default_command` | macism | macOS 用 IME 切替コマンド |
| 切替タイミング | InsertLeave, FocusGained | Insert モードを抜けたとき、ウィンドウにフォーカスが戻ったとき |

> [!NOTE]
> `macism` コマンドが必要。`brew install macism` でインストール。

### neo-tree.lua - ファイルツリー

[neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) のカスタマイズ。

| 設定 | 値 | 説明 |
|------|-----|------|
| 隠しファイル表示 | 有効 | dotfiles も表示 |
| gitignore ファイル | 表示 | .gitignore 対象も表示 |
| 非表示ファイル | .DS_Store のみ | macOS のメタファイルは非表示 |
| ファイル監視 | libuv | ファイル変更を自動検知 |
| バッファ切替時 | 自動リフレッシュ | git ステータス等を最新化 |
| 起動時動作 | 自動フォーカス | Neovim 起動時にツリーにフォーカス |

### lualine.lua - ステータスライン

[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) で現在のモードを色付きで表示。AstroNvim デフォルトの Heirline ステータスラインを無効化して置き換え。

| 設定 | 値 | 説明 |
|------|-----|------|
| テーマ | auto | カラースキームに自動追従 |
| globalstatus | true | 全ウィンドウで共通のステータスライン |
| セパレータ | なし | シンプルな見た目 |

**ステータスライン構成**:

```
[MODE] | branch diff diagnostics | filename ... encoding fileformat filetype | progress | location
```

## テンプレートファイルについて

AstroNvim テンプレートには、カスタマイズ例として無効化されたファイルが含まれている。これらは先頭に `if true then return {} end` が記述されており、必要に応じて有効化できる。

### 無効化されているファイル

| ファイル | 用途 | 有効化する場面 |
|----------|------|----------------|
| `community.lua` | AstroCommunity プラグインパック | 言語別の設定をまとめて導入したいとき |
| `polish.lua` | 最終処理（純粋な Lua コード） | 他の設定に収まらない処理を追加したいとき |
| `astrolsp.lua` | LSP の詳細設定 | フォーマット、キーマップ、サーバー設定をカスタマイズしたいとき |
| `mason.lua` | Mason でのツール自動インストール | LSP サーバーやフォーマッタを自動インストールしたいとき |
| `none-ls.lua` | フォーマッタ/リンター設定 | LSP 以外のフォーマッタやリンターを追加したいとき |
| `treesitter.lua` | Tree-sitter パーサー設定 | 特定言語のパーサーを追加インストールしたいとき |
| `user.lua` | プラグイン追加のサンプル | 新しいプラグインの追加方法を参考にしたいとき |

### 有効化方法

1. 対象ファイルを開く
2. 先頭の `if true then return {} end` を削除またはコメントアウト
3. 必要に応じて設定を編集
4. Neovim を再起動（または `:Lazy sync` を実行）

## カスタマイズ方法

### プラグインを追加する

`lua/plugins/` ディレクトリに新しい Lua ファイルを作成する。

```lua
-- lua/plugins/example.lua
return {
  "作者名/プラグイン名",
  event = "VeryLazy",  -- 遅延読み込み（任意）
  opts = {
    -- プラグインの設定
  },
}
```

### 既存プラグインの設定を変更する

同じプラグイン名で新しいファイルを作成すると、設定がマージされる。

```lua
-- lua/plugins/my-neo-tree.lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    -- 追加・上書きしたい設定のみ記述
  },
}
```

### キーマップを追加する

`astrocore.lua` の `mappings` セクションに追加する。

```lua
-- lua/plugins/astrocore.lua 内
opts = {
  mappings = {
    n = {  -- Normal モード
      ["<Leader>x"] = { "<cmd>SomeCommand<cr>", desc = "説明" },
    },
  },
}
```

### よく使うコマンド

| コマンド | 説明 |
|----------|------|
| `:Lazy` | プラグイン管理画面を開く |
| `:Lazy sync` | プラグインを同期（インストール・更新） |
| `:Mason` | LSP/ツール管理画面を開く |
| `:checkhealth` | Neovim の健全性チェック |

### 参考資料

- [AstroNvim 設定ガイド](https://docs.astronvim.com/configuration/manage_user_config/) - 公式ドキュメント
- [lazy.nvim プラグイン仕様](https://lazy.folke.io/spec) - プラグイン設定の書き方
