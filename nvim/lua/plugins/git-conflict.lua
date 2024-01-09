return {
	"akinsho/git-conflict.nvim",
	version = "*",
	opts = function()
		local k = vim.keymap.set

		k("n", "<localleader>cn", ":GitConflictNextConflict<CR>", { desc = "Next conflict" })
		k("n", "<localleader>cN", ":GitConflictPrevConflict<CR>", { desc = "Prev conflict" })
		k("n", "<localleader>co", ":GitConflictChooseOurs<CR>", { desc = "Choose ours" })
		k("n", "<localleader>ct", ":GitConflictChooseTheirs<CR>", { desc = "Choose theirs" })
		k("n", "<localleader>c0", ":GitConflictChooseNone<CR>", { desc = "Choose none" })
		k("n", "<localleader>cb", ":GitConflictChooseBoth<CR>", { desc = "Choose both" })

		return {
			disable_diagnostics = true,
			highlights = {
				current = "DiffCurrent",
				incoming = "DiffIncoming",
			},
		}
	end,
}
