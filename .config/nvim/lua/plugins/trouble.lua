-- trouble.nvim: エラー・警告・診断結果を一覧表示
-- LSP のエラーをファイルをまたいで一覧で確認できる
--
-- キーバインド:
--   <leader>xx  現在のバッファの診断を表示
--   <leader>xX  プロジェクト全体の診断を表示
--   <leader>xq  Quickfix リストを表示
--   <leader>xl  Location リストを表示

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Project diagnostics" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix list" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location list" },
    -- エラー間をジャンプ
    {
      "]x",
      function()
        require("trouble").next { skip_groups = true, jump = true }
      end,
      desc = "Next trouble item",
    },
    {
      "[x",
      function()
        require("trouble").prev { skip_groups = true, jump = true }
      end,
      desc = "Prev trouble item",
    },
  },
  opts = {},
}
