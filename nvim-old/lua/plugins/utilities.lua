return {
	{
		-- TODO turn off non-comment keywords in TodoTelescope
		"folke/todo-comments.nvim",
		lazy = false,
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufReadPost",
		opts = {
			signs = false,
			keywords = {
				NEED = {
					icon = "",
					color = "hint",
				},
			},
			highlight = {
				multiline = false,
				keyword = "bg",
				pattern = [[.*<(KEYWORDS)\s*]],
			},
			search = {
				pattern = [[\b(KEYWORDS)\b]],
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--hidden",
					"--glob=!.git",
				},
			},
		},
	},
	{
		"chrisgrieser/nvim-spider",
		config = function()
			local k = vim.keymap.set

			k({ "n", "o", "x" }, "w", function()
				require("spider").motion("w")
			end, { desc = "Spider-w" })

			k({ "n", "o", "x" }, "e", function()
				require("spider").motion("e")
			end, { desc = "Spider-e" })

			k({ "n", "o", "x" }, "b", function()
				require("spider").motion("b")
			end, { desc = "Spider-b" })

			k({ "n", "o", "x" }, "ge", function()
				require("spider").motion("ge")
			end, { desc = "Spider-ge" })
		end,
	},
	-- TODO very annoying in styled-components
	-- {
	--   "ray-x/lsp_signature.nvim",
	--   config = function()
	--     require("lsp_signature").setup({
	--       floating_window = false,
	--       hint_prefix = "",
	--       hint_scheme = "VirtualText",
	--     })
	--   end,
	-- },
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
