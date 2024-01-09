return {
	"lewis6991/gitsigns.nvim",
	opts = function()
		local k = vim.keymap.set

		k("n", "<localleader>gg", ":Gitsigns toggle_numhl<CR>", { desc = "Toggle gitsigns" })
		k("n", "<localleader>gc", ":Gitsigns change_base ", { desc = "Change gitsigns base" })
		k("n", "<localleader>gb", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle blame" })
		k("n", "<localleader>gd", ":Gitsigns toggle_deleted<CR>", { desc = "Toggle gitsigns deleted" })

		return {
			current_line_blame_opts = {
				virt_text_pos = "right_align",
				delay = 0,
			},
			signcolumn = false,
		}
	end,
}
