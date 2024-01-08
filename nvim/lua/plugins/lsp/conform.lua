return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd", "eslint_d" },
			javascriptreact = { "prettierd", "eslint_d" },
			typescript = { "prettierd", "eslint_d" },
			typescriptreact = { "prettierd", "eslint_d" },
		},
		format_on_save = {
			lsp_fallback = true, --Attempt LSP formatting if no formatters available
		},
		formatters = {
			prettierd = {
				env = {
					PRETTIERD_DEFAULT_CONFIG = vim.fn.expand(
						os.getenv("HOME") .. "/.config/nvim/.config/.prettierrc.json"
					),
				},
			},
			-- TODO Set up eslint formatting (and LSP?) to use own config if none found
			-- https://github.com/3rd/linter
		},
	},
}
