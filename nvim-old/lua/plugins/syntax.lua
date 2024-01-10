return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "BufReadPost",
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			context_commentstring = { enable = true },
			ensure_installed = {
				"bash",
				"css",
				"vimdoc",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = "<nop>",
					node_decremental = "<bs>",
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
