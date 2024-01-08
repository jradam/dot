local o = vim.opt

-- Line numbers
o.number = true
o.relativenumber = true
o.numberwidth = 3

-- Indentation
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true

-- Persistent undo
o.undodir = os.getenv("HOME") .. "/.nvim-undodir"
o.undofile = true

-- Appearance
o.signcolumn = "number"

-- Search settings
o.ignorecase = true
o.smartcase = true

-- Line breaks
o.linebreak = true
o.showbreak = "↪ "

-- Behaviour
o.scrolloff = 12

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
			vim.bo.buflisted = true -- unhide help from buffer list
			vim.cmd.only() -- put in new buffer
		end
	end,
})
