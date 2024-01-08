return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd" },
		},
		format_on_save = {
			lsp_fallback = true, --Attempt LSP formatting if no formatters available
		},
	},
}
