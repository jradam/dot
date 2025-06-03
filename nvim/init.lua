local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader
vim.g.mapleader = " "

-- Line numbers
vim.opt.relativenumber = true
vim.opt.numberwidth = 3

-- Indentation (no need for `tabstop = 2`, no tabs allowed anyway)
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Persistent undo
vim.opt.undodir = { os.getenv("HOME") .. "/.nvim-undodir" }
vim.opt.undofile = true

-- Appearance
vim.opt.signcolumn = "number"

require("lazy").setup({
  spec = { { import = "plug" } },
  install = { colorscheme = { "dracula" } },
  change_detection = { notify = false },
})
