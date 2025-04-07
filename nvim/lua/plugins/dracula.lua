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

return {
  "Mofiqul/dracula.nvim",
  opts = {
    italic_comment = true,
    overrides = function(c)
      local darkBg = "#191a21"

      return {
        -- General overrides
        Normal = { bg = darkBg },
        FloatBorder = { fg = c.comment, bg = c.bg },
        WinSeparator = { fg = c.selection, bg = darkBg }, -- Split window vertical separator

        -- Cmp (removes incorrect backgrounds from words)
        Pmenu = { bg = "NONE" },
        CmpItemAbbrMatch = { bg = "NONE", fg = c.cyan },
        CmpItemAbbr = { bg = "NONE", fg = c.fg },
        CmpItemAbbrDeprecated = { bg = "NONE", fg = c.comment },

        -- Todo-comments
        DiagnosticHint = { fg = c.green },

        -- Flash
        FlashMatch = { fg = c.green },
        FlashCurrent = { fg = c.green },
        FlashBackdrop = { fg = c.comment },
        FlashLabel = { bg = c.selection, fg = c.orange },

        -- Indent-blankline
        Indent = { fg = c.bg },
        IndentScope = { fg = c.selection },

        -- Git-conflict
        DiffCurrent = { bg = "#254C35" },
        DiffIncoming = { bg = "#423857" },

        -- Cmp
        CompletionGhostText = { fg = c.selection },

        -- Gitsigns
        GitSignsAdd = { fg = c.green },
        GitSignsChange = { fg = c.bright_white },
        GitSignsDelete = { fg = c.orange },
      }
    end,
  },
  init = function() vim.cmd([[ colorscheme dracula ]]) end,
}
