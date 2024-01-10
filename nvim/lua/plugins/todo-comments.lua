return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		signs = false,
		highlight = {
			keyword = "bg",
			pattern = [[.*<(KEYWORDS)\s*]],
		},
		search = {
			pattern = [[\b(KEYWORDS)\b]],
			-- TODO what was this for?
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
