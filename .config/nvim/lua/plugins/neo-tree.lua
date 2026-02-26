return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      width = 45,
    },
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        never_show = {
          ".DS_Store",
        },
      },
      use_libuv_file_watcher = true,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.cmd("Neotree focus")
      end,
    })
    -- Neovim にフォーカスが戻った時に Neo-tree をリフレッシュ
    vim.api.nvim_create_autocmd("FocusGained", {
      callback = function()
        pcall(vim.cmd, "Neotree refresh")
      end,
    })
  end,
}
