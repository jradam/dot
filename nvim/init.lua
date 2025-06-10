local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
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
vim.opt.number = true
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
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.signcolumn = "number"
vim.opt.scrolloff = 12
vim.opt.linebreak = true
vim.opt.showbreak = "↪ "

-- Disable swapfiles
vim.opt.swapfile = false

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
  pattern = "*",
})

-- Remove comment continuation
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  command = [[ setlocal formatoptions-=cro ]],
})

-- Load plugins
require("lazy").setup({
  spec = { { import = "plug" } },
  install = { colorscheme = { "dracula" } },
  change_detection = { notify = false },
})

-- Number highlighting for errors
local s = vim.diagnostic.severity
vim.diagnostic.config({
  float = { border = "rounded" },
  signs = {
    text = { [s.ERROR] = "", [s.WARN] = "", [s.INFO] = "", [s.HINT] = "" },
    numhl = {
      [s.ERROR] = "DiagnosticSignError",
      [s.WARN] = "DiagnosticSignWarn",
      [s.INFO] = "DiagnosticSignInfo",
      [s.HINT] = "DiagnosticSignHint",
    },
  },
})

-- Enable LSPs found in /lsp/
local lsp_configs = {}
for _, f in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
  local server_name = vim.fn.fnamemodify(f, ":t:r")
  table.insert(lsp_configs, server_name)
end
vim.lsp.enable(lsp_configs)

-- LSP help:
-- https://www.reddit.com/r/neovim/comments/1jw0zav/psa_heres_a_quick_guide_to_using_the_new_built_in/
-- https://github.com/ruicsh/nvim-config/tree/main/lsp

-- TODO: parrot
-- TODO: local/git changes picker, open on start
-- TODO: Spyglass todo picker
-- TODO: conflict management
