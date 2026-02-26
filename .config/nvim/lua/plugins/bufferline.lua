return {
  -- bufferline.nvim: バッファをタブのように表示
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        mode = "buffers",
        numbers = "none",
        close_command = function(n) require("astrocore.buffer").close(n) end,
        right_mouse_command = function(n) require("astrocore.buffer").close(n) end,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
        show_buffer_close_icons = true,
        show_close_icon = false,
        separator_style = "thin",
        indicator = {
          style = "icon",
          icon = "▎",
        },
      },
      highlights = {
        -- 非アクティブは透明
        fill = { bg = "NONE" },
        background = { bg = "NONE", fg = "#6e7681" },
        buffer_visible = { bg = "NONE", fg = "#6e7681" },
        -- アクティブは背景色をつけて目立たせる
        buffer_selected = {
          bg = "#30363d",
          fg = "#e6edf3",
          bold = true,
          italic = false,
        },
        separator = { bg = "NONE", fg = "#21262d" },
        separator_visible = { bg = "NONE", fg = "#21262d" },
        separator_selected = { bg = "#30363d", fg = "#21262d" },
        indicator_selected = { bg = "#30363d", fg = "#58a6ff" },
        close_button = { bg = "NONE", fg = "#6e7681" },
        close_button_visible = { bg = "NONE", fg = "#6e7681" },
        close_button_selected = { bg = "#30363d", fg = "#e6edf3" },
        tab = { bg = "NONE" },
        tab_selected = { bg = "#30363d" },
        tab_separator = { bg = "NONE" },
        tab_separator_selected = { bg = "#30363d" },
        duplicate = { bg = "NONE", fg = "#6e7681", italic = true },
        duplicate_visible = { bg = "NONE", fg = "#6e7681", italic = true },
        duplicate_selected = { bg = "#30363d", fg = "#e6edf3", italic = true },
        modified = { bg = "NONE", fg = "#d29922" },
        modified_visible = { bg = "NONE", fg = "#d29922" },
        modified_selected = { bg = "#30363d", fg = "#d29922" },
        diagnostic = { bg = "NONE" },
        diagnostic_visible = { bg = "NONE" },
        diagnostic_selected = { bg = "#30363d" },
        hint = { bg = "NONE" },
        hint_visible = { bg = "NONE" },
        hint_selected = { bg = "#30363d" },
        info = { bg = "NONE" },
        info_visible = { bg = "NONE" },
        info_selected = { bg = "#30363d" },
        warning = { bg = "NONE", fg = "#d29922" },
        warning_visible = { bg = "NONE", fg = "#d29922" },
        warning_selected = { bg = "#30363d", fg = "#d29922" },
        error = { bg = "NONE", fg = "#f85149" },
        error_visible = { bg = "NONE", fg = "#f85149" },
        error_selected = { bg = "#30363d", fg = "#f85149" },
        numbers = { bg = "NONE" },
        numbers_visible = { bg = "NONE" },
        numbers_selected = { bg = "#30363d" },
      },
    },
  },

  -- Heirline の tabline を無効化
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      opts.tabline = nil
      return opts
    end,
  },
}
