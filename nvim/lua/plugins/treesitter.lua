return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		-- TODO the errors here and throughout the project

		configs.setup({
			highlight = { enable = true },
			ensure_installed = {
				"bash",
				"css",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"tsx",
				"typescript",
				"vimdoc",
				"yaml",
			},
		})
	end,
}
