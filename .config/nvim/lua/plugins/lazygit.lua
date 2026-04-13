-- LazyGit: Git TUI クライアント
-- <leader>gg で Neovim 内からフローティングウィンドウで起動
-- Claude Code が変更したファイルの確認・コミットに便利

return {
  "folke/snacks.nvim",
  opts = {
    lazygit = { enabled = true },
  },
  keys = {
    {
      "<leader>gg",
      function() Snacks.lazygit() end,
      desc = "Open LazyGit",
    },
    {
      "<leader>gf",
      function() Snacks.lazygit.log_file() end,
      desc = "LazyGit current file history",
    },
  },
}
