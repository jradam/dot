return {
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    opts = function()
      local c = require("dracula").colors()
      local darkBg = "#191a21"

      return {
        italic_comment = true,
        overrides = {
          -- high contrast
          Normal = { bg = darkBg },
          -- floats, mid-point border colour is "#21222C"
          NormalFloat = { bg = c.bg },
          FloatBorder = { fg = c.comment, bg = c.bg },
          -- completion menu, remove incorrect backgrounds from words
          Pmenu = { bg = "NONE" },
          CmpItemAbbrMatch = { bg = "NONE", fg = c.cyan },
          CmpItemAbbr = { bg = "NONE", fg = c.fg },
          CmpItemAbbrDeprecated = { bg = "NONE", fg = c.comment },
          -- completion ghost text
          CompletionGhostText = { fg = c.selection },
          -- LSP info floats
          LspInfoList = { bg = c.purple },
          LspInfoFiletype = { bg = c.orange },
          LspInfoTip = { bg = c.blue },
          LspInfoBorder = { bg = c.yellow },
          -- nvim tree
          NvimTreeNormal = { bg = c.bg },
          NvimTreeFolderName = { fg = c.white },
          NvimTreeFolderIcon = { fg = c.white },
          NvimTreeOpenedFolderName = { fg = c.purple },
          NvimTreeOpenedFolderIcon = { fg = c.purple },
          -- diagnostics
          WarningMsg = { fg = c.orange },
          DiagnosticWarn = { fg = c.orange },
          DiagnosticUnderlineWarn = { sp = c.orange },
          DiagnosticSignWarn = { fg = c.orange },
          DiagnosticFloatingWarn = { fg = c.orange },
          DiagnosticVirtualTextWarn = { fg = c.orange },
          LspDiagnosticsDefaultWarning = { fg = c.orange },
          LspDiagnosticsUnderlineWarning = { fg = c.orange },
          -- hover info
          VirtualText = { fg = c.bright_yellow },
          -- Gitsigns
          GitSignsAddNr = { fg = c.bg, bg = c.green },
          GitSignsChangeNr = { fg = c.bg, bg = c.purple },
          GitSignsDeleteNr = { fg = c.bg, bg = c.red },
          GitSignsAddLnInline = { fg = c.bg, bg = c.green },
          GitSignsChangeLnInline = { fg = c.bg, bg = c.purple },
          GitSignsDeleteLnInline = { fg = c.bg, bg = c.red },
          -- for todos
          DiagnosticInfo = { fg = c.cyan },
          DiagnosticHint = { fg = c.green },
          -- for ai
          ChatBorder = { fg = c.orange },
          ChatBackground = { fg = c.bg },
          -- TODO what are these for?
          -- Notifications
          NotifyBackground = { bg = c.comment },
          -- Flash movement
          FlashBackdrop = { fg = c.comment },
          FlashMatch = { fg = c.green },
          FlashCurrent = { fg = c.green },
          FlashLabel = { bg = c.selection, fg = c.orange },
          -- For indent lines
          -- Indent = { fg = #282A36 },
          -- IndentBlanklineContextChar = { fg = #44475A },
          Indent = { fg = c.bg },
          IndentScope = { fg = c.selection },
        },
      }
    end,
    init = function()
      vim.cmd([[ colorscheme dracula ]])
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        highlight = {
          "Indent",
        }
      },
      scope = {
        show_start = false,
        highlight = {
          "IndentScope",
        }
      }
    },
  },
}


-- https://github.com/Mofiqul/dracula.nvim
-- https://github.com/Mofiqul/dracula.nvim/blob/main/lua/dracula/groups.lua

-- colors = {
--   bg = "#282A36",
--   fg = "#F8F8F2",
--   selection = "#44475A",
--   comment = "#6272A4",
--   red = "#FF5555",
--   orange = "#FFB86C",
--   yellow = "#F1FA8C",
--   green = "#50fa7b",
--   purple = "#BD93F9",
--   cyan = "#8BE9FD",
--   pink = "#FF79C6",
--   bright_red = "#FF6E6E",
--   bright_green = "#69FF94",
--   bright_yellow = "#FFFFA5",
--   bright_blue = "#D6ACFF",
--   bright_magenta = "#FF92DF",
--   bright_cyan = "#A4FFFF",
--   bright_white = "#FFFFFF",
--   menu = "#21222C",
--   visual = "#3E4452",
--   gutter_fg = "#4B5263",
--   nontext = "#3B4048",
-- }
