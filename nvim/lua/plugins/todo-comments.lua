return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		signs = false,
		highlight = {
			pattern = [[.*<(KEYWORDS)\s*:]],
		},
		search = {
			pattern = [[\b(KEYWORDS):]],
			-- TODO: what was this for?
			-- args = {
			-- 	"--color=never",
			-- 	"--no-heading",
			-- 	"--with-filename",
			-- 	"--line-number",
			-- 	"--column",
			-- 	"--hidden",
			-- 	"--glob=!.git",
			-- },
		},
	},
}
