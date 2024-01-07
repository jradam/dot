local k = vim.keymap.set

-- Actions
k("n", "<leader>w", ":w<CR>", { desc = "Write" })
k("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Text manipulation
k("n", "<leader>a", "ggVG", { desc = "Select all" })
k("v", "<C-c>", [["+y]], { desc = "System clip" })
k("v", "<leader>r", [[:s/\%V//g<Left><Left><Left>]], { desc = "Replace" })

-- Navigation
k("n", "<Tab>", ":bn<CR>", { desc = "Next buffer", silent = true })
k("n", "<S-Tab>", ":bp<CR>", { desc = "Prev buffer", silent = true })
k("n", "<leader>x", ":bd<CR>", { desc = "Close buffer" })
k("n", "<leader>j", "<C-]>", { desc = "Jump to tag" })
k("n", "j", "gj", { desc = "Visual move up" })
k("n", "k", "gk", { desc = "Visual move down" })
