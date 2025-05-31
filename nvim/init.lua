-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader
vim.g.mapleader = " "

-- Check for file changes when entering insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function() vim.cmd("checktime") end,
})

require("conf.lazy")
require("conf.opts")
require("conf.maps")

require("conf.util").setup_lsp()

