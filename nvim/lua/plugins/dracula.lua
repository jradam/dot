return {
  "Mofiqul/dracula.nvim",
  opts = function()
    local c = require("dracula").colors()
    local darkBg = "#191a21"

    return {
      italic_comment = true,
      overrides = {
	Normal = { bg = darkBg },
	FloatBorder = { fg = c.comment, bg = c.bg },

	-- Split window vertical separator
	WinSeparator = { fg = c.selection, bg = darkBg },

	-- Completion menu (removes incorrect backgrounds from words)
	Pmenu = { bg = "NONE" },
	CmpItemAbbrMatch = { bg = "NONE", fg = c.cyan },
	CmpItemAbbr = { bg = "NONE", fg = c.fg },
	CmpItemAbbrDeprecated = { bg = "NONE", fg = c.comment },

	-- Flash movement
	FlashMatch = { fg = c.green },
	FlashCurrent = { fg = c.green },
	FlashBackdrop = { fg = c.comment },
	FlashLabel = { bg = c.selection, fg = c.orange },
      }
    }
  end,
  init = function()
    vim.cmd([[ colorscheme dracula ]])
  end,
}
