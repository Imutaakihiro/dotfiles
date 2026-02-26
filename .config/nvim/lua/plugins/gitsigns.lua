return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true, -- GitLensのようにインラインでblame表示
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 行末に表示
      delay = 300, -- 表示までの遅延(ms)
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  },
}
