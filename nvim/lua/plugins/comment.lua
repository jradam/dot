return {
	"numToStr/Comment.nvim",
	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	config = function()
		require("ts_context_commentstring").setup({ enable_autocmd = false })

		local integration = require("ts_context_commentstring.integrations.comment_nvim")
		require("Comment").setup({
			pre_hook = integration.create_pre_hook(),
		})
	end,
}
