-- Mason: LSP サーバー・フォーマッター・リンターを自動インストール

---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- === LSP サーバー ===
        "gopls",                    -- Go
        "typescript-language-server", -- TypeScript / JavaScript
        "pyright",                  -- Python
        "lua-language-server",      -- Lua（Neovim 設定ファイル用）
        "css-lsp",                  -- CSS
        "html-lsp",                 -- HTML

        -- === フォーマッター ===
        "stylua",                   -- Lua フォーマッター
        "prettierd",                -- TypeScript / JavaScript / CSS / HTML

        -- === リンター ===
        "eslint_d",                 -- TypeScript / JavaScript

        -- === その他 ===
        "tree-sitter-cli",
      },
    },
  },
}
