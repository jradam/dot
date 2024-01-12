return {
	"NvChad/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup({
			user_default_options = {
				names = false,
				css = true,
				tailwind = "lsp",
				mode = "virtualtext",
				virtualtext = "",
			},
		})
	end,
}
