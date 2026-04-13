-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      opt = {
        wrap = true,        -- 折り返しを有効化
        linebreak = true,   -- 単語の途中で折り返さない
        breakindent = true, -- 折り返し行もインデントを維持
        cursorline = true,  -- カーソルラインを有効化
        swapfile = false,   -- スワップファイルを無効化（Git + undofile で十分）
      },
    },
    mappings = {
      n = {
        -- Tab でバッファを移動（ブラウザのタブ操作と同じ感覚）
        ["<Tab>"] = { "<cmd>bnext<cr>", desc = "Next buffer" },
        ["<S-Tab>"] = { "<cmd>bprevious<cr>", desc = "Previous buffer" },
      },
    },
    autocmds = {
      -- 外部ツール（Claude Code など）がファイルを変更したら自動リロード
      auto_reload = {
        {
          event = { "FocusGained", "BufEnter", "CursorHold" },
          command = "silent! checktime",
        },
        {
          event = "FileChangedShell",
          callback = function() vim.v.fcs_choice = "reload" end,
        },
      },
      -- ファイルを開いた時に空の [No Name] バッファを削除
      cleanup_noname = {
        {
          event = "BufReadPost",
          callback = function()
            vim.schedule(function()
              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_valid(buf)
                  and vim.api.nvim_buf_get_name(buf) == ""
                  and vim.bo[buf].buftype == ""
                  and vim.api.nvim_buf_line_count(buf) <= 1
                  and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
                then
                  pcall(vim.api.nvim_buf_delete, buf, {})
                end
              end
            end)
          end,
        },
      },
      -- アクティブウィンドウのみカーソルラインを表示
      active_window_cursorline = {
        {
          event = "VimEnter",
          callback = function()
            -- 起動時: 現在のウィンドウ以外のカーソルラインをオフ
            local current_win = vim.api.nvim_get_current_win()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if win ~= current_win then
                vim.api.nvim_set_option_value("cursorline", false, { win = win })
              end
            end
          end,
        },
        {
          event = { "WinEnter", "BufEnter" },
          callback = function() vim.opt_local.cursorline = true end,
        },
        {
          event = { "WinLeave", "BufLeave" },
          callback = function() vim.opt_local.cursorline = false end,
        },
      },
    },
  },
}
