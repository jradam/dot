return {
  "Mofiqul/dracula.nvim",
  opts = {
    italic_comment = true,
    overrides = function(c)
      local darkBg = "#191a21"
      local darkGreen = "#254C35"
      local darkPurple = "#423857"
      local darkRed = "#3A1D24"

      return {
        Normal = { bg = darkBg },
        FloatBorder = { fg = c.comment, bg = c.bg },

        -- For Git conflicts
        DiffCurrent = { bg = darkGreen },
        DiffIncoming = { bg = darkPurple },

        -- For the Gitsigns line highlights
        GitSignsAdd = { bg = darkPurple },
        GitSignsChange = { reverse = true },
        GitSignsDelete = { bg = darkBg, undercurl = true },

        -- For the Gitsigns inline previews
        DiffDelete = { bg = darkBg, fg = c.red },
        GitSignsAddPreview = { bg = darkBg, fg = c.green },
        GitSignsAddInline = { bg = darkPurple, fg = c.purple },
        GitSignsChangeInline = { bg = darkGreen, fg = c.green },
        GitSignsDeleteLnInline = { bg = darkRed, fg = c.red },

        -- Flash
        FlashMatch = { fg = c.cyan },
        FlashCurrent = { fg = c.cyan },
        FlashBackdrop = { fg = c.comment, bg = darkBg },
        FlashLabel = { fg = c.green },

        -- Indent lines
        Indent = { fg = c.bg },
      }
    end,
  },
  init = function() vim.cmd([[ colorscheme dracula ]]) end,
}

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
