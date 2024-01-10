return {
	"Mofiqul/dracula.nvim",
	opts = function()
		local c = require("dracula").colors()
		local darkBg = "#191a21"

		return {
			italic_comment = true,
			overrides = {
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
			},
		}
	end,
	init = function()
		vim.cmd([[ colorscheme dracula ]])
	end,
}
