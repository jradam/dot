local k = vim.keymap.set

-- Actions
k("n", "<leader>w", function()
  vim.cmd("checktime") -- check for changes before saving
  vim.cmd("w")
end, { desc = "Write" })

k("n","<leader>e", function() vim.cmd("NvimTreeToggle") end, {desc = "Tree"})

vim.api.nvim_create_autocmd({"InsertEnter", "InsertLeave", "WinEnter", "BufEnter"}, {
  callback = function() vim.cmd("checktime") end,
}) -- Check for file changes when changing modes 

-- Text manipulation
k("n", "<leader>a", "ggVG", { desc = "Select all" })
k("v", "<C-c>", [["+y]], { desc = "System clip" })
k("v", "<leader>r", [[:s/\%V//g<Left><Left><Left>]], { desc = "Replace" })
k("n", "K", "i<space><left>", { desc = "Insert space" })

