-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      codelens = true,
      inlay_hints = false,
      semantic_tokens = true,
    },
    formatting = {
      format_on_save = {
        enabled = true,
        allow_filetypes = {
          "go", -- Go は保存時に自動フォーマット
        },
      },
      disabled = {
        "lua_ls", -- Lua は stylua でフォーマットするため無効化
      },
      timeout_ms = 1000,
    },
    -- Mason で自動インストールするサーバー
    servers = {
      "gopls",      -- Go
      "ts_ls",      -- TypeScript / JavaScript
      "pyright",    -- Python
      "lua_ls",     -- Lua（Neovim 設定ファイル用）
      "cssls",      -- CSS
      "html",       -- HTML
    },
    config = {
      -- Go: 静的解析・フォーマットを強化
      gopls = {
        settings = {
          gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
            gofumpt = true,
          },
        },
      },
      -- Python: 型チェックを基本レベルで有効化
      pyright = {
        settings = {
          python = {
            analysis = { typeCheckingMode = "basic" },
          },
        },
      },
    },
    mappings = {
      n = {
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
      },
    },
  },
}
