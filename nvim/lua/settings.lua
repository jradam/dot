local o = vim.opt

-- Line numbers
o.number = true
o.relativenumber = true
o.numberwidth = 3

-- TODO add tpope/vim-sleuth?
-- Indentation
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

-- Persistent undo
o.undodir = { os.getenv("HOME") .. "/.nvim-undodir" }
o.undofile = true

-- Appearance
o.signcolumn = "number"
o.showmode = false
o.termguicolors = true

-- Search settings
o.ignorecase = true
o.smartcase = true

-- Line breaks
o.linebreak = true
o.showbreak = "↪ "

-- Behaviour
o.scrolloff = 12

-- Disable swapfiles
o.swapfile = false

-- Global timeout, affects leader keys and plugins like which-key
o.timeoutlen = 500

-- Global interactivity, affects CursorHold event and plugins like local-highlight
o.updatetime = 1000

-- Remove comment continuation
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	command = [[ setlocal formatoptions-=cro ]],
})

-- Send `<Esc>` on focus loss to enter normal mode
vim.api.nvim_create_autocmd("FocusLost", {
	pattern = "*",
	command = "lua vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)",
})

-- Open help files in a new buffer
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	callback = function(event)
		local type = vim.bo[event.buf].filetype

		if type == "help" or type == "markdown" then
			-- Unhide and put in own buffer
			vim.bo.buflisted = true
			vim.cmd.only()
		end
	end,
})

-- Spelling for markdown files
vim.api.nvim_create_autocmd("BufRead", {
	pattern = "*.md",
	command = [[ setlocal spell ]],
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	pattern = "*",
})
