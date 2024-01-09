return {
	"axkirillov/easypick.nvim",
	dependencies = "nvim-telescope/telescope.nvim",
	keys = {
		{ "<leader>g", ":Easypick<CR>", desc = "Git telescope" },
	},
	opts = function()
		local easypick = require("easypick")

		return {
			pickers = {
				{
					name = "Local changes",
					command = "git diff --name-only",
					previewer = easypick.previewers.branch_diff({}),
				},
				{
					name = "Changed from main",
					command = "git diff --name-only main",
					previewer = easypick.previewers.branch_diff({ base_branch = "main" }),
				},
				{
					name = "Conflicts",
					command = "git diff --name-only --diff-filter=U --relative",
					previewer = easypick.previewers.file_diff(),
				},
			},
		}
	end,
}
