local k = vim.keymap.set
-- local all_modes = {
-- 	"n", -- Normal
-- 	"v", -- Visual and Select
-- 	"s", -- Select
-- 	"x", -- Visual
-- 	"o", -- Operator-pending
-- 	"!", -- Insert and Command-line
-- 	"i", -- Insert
-- 	-- "l", -- ":lmap" mappings for Insert, Command-line and Lang-Arg
-- 	"c", -- Command-line
-- 	"t", -- Terminal-Job
-- }

-- change behaviour
k("n", "q", "<Nop>", { desc = "disable recording" })
k("n", "x", '"_x', { desc = "delete without register" })
k("x", "p", [["_dP]], { desc = "copyless paste" })

-- remaps
k("t", "<c-q>", "<C-\\><C-n>", { desc = "exit terminal insert" })
k("n", "c", ":noh<cr>", { desc = "clear" })
k("n", "C", "<cmd>LspRestart<cr>:edit<cr>", { desc = "redraw, restart" })
-- Default terminal ctrl+backspace also sends C-h which I use for tmux tabs. Remap to C-w.

-- controls
k("n", "<leader>w", ":w<CR>", { desc = "write" })
k("n", "<leader>q", ":q<CR>", { desc = "quit" })

-- navigation
k("n", "<Tab>", ":bn<CR>", { desc = "next buffer", silent = true })
k("n", "<S-Tab>", ":bp<CR>", { desc = "prev buffer", silent = true })
k("n", "<leader>x", ":bd<CR>", { desc = "close buffer" })
k("n", "<leader>j", "<C-]>", { desc = "jump to tag" })

-- in-buffer navigation
k("n", "<C-d>", "<C-d>zz", { desc = "jump down" })
k("n", "<C-u>", "<C-u>zz", { desc = "jump up" })

-- select / copy / delete
k("n", "<leader>a", "ggVG", { desc = "select all" })
-- TODO make case sensitive
k("v", "<leader>r", [[:s/\%V//g<Left><Left><Left>]], { desc = "replace" })
k("v", "<c-c>", [["+y]], { desc = "system clip" })
k("v", "<leader>d", [["_d]], { desc = "black hole" })

-- other
k("n", "K", "i<space><left>", { desc = "insert space" })
k("v", "o", ":sort<CR>", { desc = "sort" })
k("n", "<leader>m", ":messages<cr>", { desc = "messages" })

-- -- replace word in file
-- k("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "replace all" })
-- -- k("n", "<leader>n", [[:%s//]], { desc = "replace selection" })
--
--
-- k("n", "<leader>sx", "ciw<Del><BS><Esc>p", { desc = "delete surround" })
-- k("n", "<leader>sd", "ciw\"\"<Esc>P", { desc = "surround double" })
-- k("n", "<leader>ss", "ciw\'\'<Esc>P", { desc = "surround single" })
--
--
--
-- -- show all keys
-- k("n", "<leader>w", ":WhichKey<CR>", { desc = "show keys" })
--
--
-- -- implement :unhide somehow
--
-- -- implement <Esc> to `:q<CR>` unmodifiable buffers (i.e. if in diagnostic float, press esc to quit, since can't insert anyway)
-- --- OR EVEN BETTER make Esc close all unmodifiable buffers
--
-- -- jump to beginning or end of lines
-- k({ "n", "v" }, "<leader>h", "^", { desc = "Line start" })
-- k({ "n", "v" }, "<leader>m", "gM", { desc = "Line mid" })
-- k({ "n", "v" }, "<leader>l", "$", { desc = "Line end" })
