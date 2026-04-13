return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true, -- GitLens のようにインラインで blame 表示
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 行末に表示
      delay = 300,           -- 表示までの遅延(ms)
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local map = function(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end
      -- 変更ハンクを前後に移動
      map("n", "gh", function() gs.next_hunk() end, "Next git hunk")
      map("n", "gH", function() gs.prev_hunk() end, "Prev git hunk")
    end,
  },
}
