-- todo-comments.nvim: コメント内のキーワードをハイライト
--
-- 対応キーワード:
--   TODO:   やること
--   FIXME:  バグ・修正が必要な箇所
--   NOTE:   メモ・補足説明
--   HACK:   応急処置・汚いコード
--   WARN:   注意が必要な箇所
--   PERF:   パフォーマンス改善候補
--
-- <leader>ft でプロジェクト内の TODO を一覧表示（Telescope 連携）

return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  opts = {},
  keys = {
    { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
  },
}
