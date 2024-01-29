local k = vim.keymap.set
local h = require("helpers")

-- Disable
k("n", "q", "<Nop>", { desc = "Disable recording" })
k("n", "x", '"_x', { desc = "Delete without register" })

-- Actions
k("n", "<leader>w", ":w<CR>", { desc = "Write" })
k("n", "<leader>q", ":q<CR>", { desc = "Quit" })
k("n", "<leader>m", ":messages<CR>", { desc = "Show messages" })
k("n", "<leader>M", ":messages clear<CR>", { desc = "Clear messages" })
k("n", "c", ":noh<cr>", { desc = "Clear highlights" })
k("n", "C", ":edit<cr>:LspRestart<cr>", { desc = "Restart buffer" })
k("t", "<c-q>", "<C-\\><C-n>", { desc = "Exit terminal insert" })
k("n", "<leader>c", ":source<CR>", { desc = "Source config" })

-- Text manipulation
k("n", "<leader>a", "ggVG", { desc = "Select all" })
k("v", "<C-c>", [["+y]], { desc = "System clip" })
k("v", "<leader>r", [[:s/\%V//g<Left><Left><Left>]], { desc = "Replace" })
k("n", "K", "i<space><left>", { desc = "Insert space" })
k("v", "o", ":sort<CR>", { desc = "Sort" })
k("x", "p", [["_dP]], { desc = "Copyless paste" })
k("v", "<leader>d", [["_d]], { desc = "Black hole" })

-- Navigation
k("n", "<leader>j", "<C-]>", { desc = "Jump to tag" })
k("n", "j", "gj", { desc = "Visual move up" })
k("n", "k", "gk", { desc = "Visual move down" })
k("n", "<C-d>", "<C-d>zz", { desc = "Jump down" })
k("n", "<C-u>", "<C-u>zz", { desc = "Jump up" })
k("n", "<leader>v", "^", { desc = "Line start" })
k("n", "<leader>b", "gM", { desc = "Line mid" })
k("n", "<leader>n", "$", { desc = "Line end" })

-- Close floating windows with `<Esc>`
k(
  "n",
  "<Esc>",
  function() h.close_floats() end,
  { desc = "Close floats", silent = true }
)

-- Remaps
-- FIXME: I think we just need a new keyboard layer with AHK
-- k("i", ";", "", { desc = "Remove `;` from insert mode" })

k("i", ";f", "{", { desc = "{" })
k("i", ";j", "}", { desc = "}" })

k("i", ";d", "(", { desc = "(" })
k("i", ";k", ")", { desc = ")" })

k("i", ";s", "[", { desc = "[" })
k("i", ";l", "]", { desc = "]" })

k("i", ";u", "_", { desc = "_" })
k("i", ";h", "-", { desc = "-" })
k("i", ";q", '"', { desc = '"' })

k("i", ";e", "=", { desc = "=" })
k("i", ";c", ";", { desc = ";" })

k("i", ";n", "<CR>", { desc = "Newline" })
-- TODO: make these do a word at a time
k("i", ";b", "<Backspace>", { desc = "Backspace" })
k("i", ";x", "<Delete>", { desc = "Delete" })
