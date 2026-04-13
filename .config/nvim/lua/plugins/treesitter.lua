-- Treesitter: 構文解析エンジン
-- コードの構文ハイライト・インデント・テキストオブジェクトを大幅に強化する
-- render-markdown.nvim など多くのプラグインも依存している

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      -- === 基本 ===
      "lua",        -- Neovim 設定ファイル
      "vim",        -- Vim script
      "vimdoc",     -- Neovim ヘルプドキュメント
      "bash",       -- シェルスクリプト

      -- === バックエンド ===
      "go",         -- Go
      "gomod",      -- go.mod
      "python",     -- Python

      -- === フロントエンド ===
      "typescript", -- TypeScript
      "javascript", -- JavaScript
      "tsx",        -- React (TypeScript)
      "jsx",        -- React (JavaScript)
      "html",       -- HTML
      "css",        -- CSS
      "json",       -- JSON
      "yaml",       -- YAML

      -- === ドキュメント ===
      "markdown",         -- Markdown（Obsidian ノート含む）
      "markdown_inline",  -- Markdown インライン要素
    },
    -- コードに合わせて自動インデント
    indent = { enable = true },
  },
}
