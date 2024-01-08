return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = {
		-- FIXME opts not working
		-- TODO implement a menu with all the tools/or setup shortcuts
		tsserver_plugins = {
			"@styled/typescript-styled-plugin",
		},
		jsx_close_tag = {
			enable = true,
			filetypes = { "javascriptreact", "typescriptreact" },
		},
	},
	config = function(_, opts)
		require("typescript-tools").setup(opts)
	end,
}
