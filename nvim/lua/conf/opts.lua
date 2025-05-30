local o = vim.opt

-- Line numbers
o.relativenumber = true
o.numberwidth = 3

-- Indentation (no need for `tabstop = 2`, no tabs allowed anyway)
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true
o.breakindent = true

-- Persistent undo
o.undodir = { os.getenv("HOME") .. "/.nvim-undodir" }
o.undofile = true

