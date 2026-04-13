-- diffview.nvim: git の差分をパネル表示で確認
-- Claude Code が作成した変更内容を視覚的に確認するのに便利
return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview (git diff)" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File git history" },
  },
  opts = {
    enhanced_diff_hl = true, -- 差分をよりカラフルに表示
    view = {
      default = {
        layout = "diff2_horizontal", -- 上下に分割して差分表示
      },
    },
    file_panel = {
      win_config = {
        width = 35,
      },
    },
  },
}
