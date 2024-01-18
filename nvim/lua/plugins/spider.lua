return {
	"chrisgrieser/nvim-spider",
	config = function()
		local k = vim.keymap.set
		-- Must be Ex-commands like this for dot-repeatability to work
		k({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
		k({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
		k({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
	end,
}
