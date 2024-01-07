local k = vim.keymap.set

-- Actions
k("n", "<leader>w", ":w<CR>", { desc = "write" })
k("n", "<leader>q", ":q<CR>", { desc = "quit" })

-- Text manipulation
k("n", "<leader>a", "ggVG", { desc = "select all" })

-- Navigation
k("n", "<Tab>", ":bn<CR>", { desc = "next buffer", silent = true })
k("n", "<S-Tab>", ":bp<CR>", { desc = "prev buffer", silent = true })
