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

-- Appearance
o.signcolumn = "number"

-- Number highlighting for errors
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    }
  }
})

