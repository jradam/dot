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

	-- Completion menu, remove incorrect backgrounds from words
	Pmenu = { bg = "NONE" },
	CmpItemAbbrMatch = { bg = "NONE", fg = c.cyan },
	CmpItemAbbr = { bg = "NONE", fg = c.fg },
	CmpItemAbbrDeprecated = { bg = "NONE", fg = c.comment },
      }
    }

  end,
  init = function()
    vim.cmd([[ colorscheme dracula ]])
  end,
}
