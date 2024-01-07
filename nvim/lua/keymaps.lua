local k = vim.keymap.set

-- Actions
k("n", "<leader>w", ":w<CR>", { desc = "Write" })
k("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Text manipulation
k("n", "<leader>a", "ggVG", { desc = "Select all" })
k("v", "<c-c>", [["+y]], { desc = "System clip" })

-- Navigation
k("n", "<Tab>", ":bn<CR>", { desc = "Next buffer", silent = true })
k("n", "<S-Tab>", ":bp<CR>", { desc = "Prev buffer", silent = true })
