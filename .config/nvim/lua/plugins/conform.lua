-- conform.nvim: 保存時の自動フォーマット
-- LSP のフォーマットより高速・細かく制御できる

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      -- TypeScript / JavaScript
      typescript = { "prettierd", "prettier", stop_after_first = true },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      -- Web
      html = { "prettierd", "prettier", stop_after_first = true },
      css = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd", "prettier", stop_after_first = true },
      -- Python
      python = { "ruff_format" },
      -- Lua
      lua = { "stylua" },
      -- Markdown（Obsidian ノート含む）
      markdown = { "prettierd", "prettier", stop_after_first = true },
    },
    -- 保存時に自動フォーマット
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback", -- conform が対応していない言語は LSP にフォールバック
    },
  },
}
