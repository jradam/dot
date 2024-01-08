return {
	"tzachar/local-highlight.nvim",
	config = function()
		require("local-highlight").setup({
			disable_file_types = { "markdown" },
			hlgroup = "CursorLine",
		})
	end,
}
