local o = vim.opt

-- Line numbers
o.number = true
o.relativenumber = true
o.numberwidth = 3

-- Indentation
o.shiftwidth = 2

-- Persistent undo
o.undodir = os.getenv("HOME") .. "/.nvim-undodir"
o.undofile = true

-- Remove comment continuation
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  command = [[ setlocal formatoptions-=cro ]],
})

-- Other 
o.scrolloff = 12


