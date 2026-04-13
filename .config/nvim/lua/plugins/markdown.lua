-- Markdown 編集・プレビュー強化
-- Obsidian ノートを Neovim で快適に編集するための設定

return {
  -- ブラウザでリアルタイムプレビュー
  -- <leader>mp でブラウザが開き、編集と同時にレンダリングされる
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview (browser)" },
    },
    config = function()
      -- テーマをダークモードに
      vim.g.mkdp_theme = "dark"
      -- ブラウザを自動で開く
      vim.g.mkdp_auto_start = 0
      -- Neovim を閉じたらプレビューも閉じる
      vim.g.mkdp_auto_close = 1
    end,
  },

  -- Neovim 内でそのままレンダリング（Obsidian のような表示）
  -- 見出し・太字・テーブル・コードブロックを視覚的に表示
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {
      -- 見出しレベルごとに色分け
      heading = { enabled = true },
      -- コードブロックに背景色
      code = { enabled = true, style = "full" },
      -- テーブルを綺麗に整形
      pipe_table = { enabled = true },
      -- チェックボックス（- [ ] / - [x]）を視覚的に表示
      checkbox = { enabled = true },
      -- 箇条書きの記号をアイコンに変換
      bullet = { enabled = true },
    },
  },
}
