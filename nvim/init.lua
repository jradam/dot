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

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

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

-- Spelling for markdown files
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.md",
  command = [[ setlocal spell ]],
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

-- Jumping to diagnostic should open it
vim.diagnostic.config({ jump = { float = true } })

-- LSP help:
-- https://www.reddit.com/r/neovim/comments/1jw0zav/psa_heres_a_quick_guide_to_using_the_new_built_in/
-- https://github.com/ruicsh/nvim-config/tree/main/lsp

-- FIXME: troubleshoot rs project - make sure typescript is working!

-- TODO: button that refactors arrow into normal function and vice-versa
-- TODO: line blame
-- TODO: make ctrl-v work in claude code terminal the same as right-click/paste
-- TODO: always put import files at top of code actions if exists. Also, can we pre-load these on bufopen and bufwrite?
-- TODO: keychef: m: $, brackets
-- TODO: Undo delete of file in tree?
-- TODO: Add small version of Claude in a small popup (bottom right?) that just gets the current buffer as context. Bonus if it automatically takes highlighted text in the input when opened
-- TODO: Way to save without formatting
-- TODO: bigfile.nvim?
-- TODO: https://stackoverflow.com/questions/171326/how-can-i-increase-the-key-repeat-rate-beyond-the-oss-limit

-- TODO: Troubleshoot copy/paste issues with terminals, mouse pasting differences, etc
-- k("v", "<C-c>", [["+y]], { desc = "System clip" })

-- TODO: work out how to do ctrl+space like before (in treesitter?)
-- incremental_selection = {
--   enable = true,
--   keymaps = {
--     init_selection = "<C-Space>",
--     node_incremental = "<C-Space>",
--     node_decremental = "<BS>",
--   },
-- },


-- TODO: add tailwind support to prettier
-- "plugins": ["prettier-plugin-tailwindcss"],
-- "tailwindFunctions": ["cn"]

-- TODO: add vim.lsp status somehow to lualine

-- TODO: markdown preview?
-- return {
--   "iamcco/markdown-preview.nvim",
--   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
--   build = "cd app && yarn install",
--   init = function() vim.g.mkdp_filetypes = { "markdown" } end,
--   ft = { "markdown" },
-- }
--

-- TODO: chrisgrieser/nvim-spider ?

-- TODO: this
-- -- Send `<Esc>` on focus loss to enter normal mode (when not terminal)
-- vim.api.nvim_create_autocmd("FocusLost", {
--   pattern = "*",
--   callback = function()
--     if vim.bo.buftype ~= "terminal" then
--       vim.api.nvim_feedkeys(
--         vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
--         "n",
--         true
--       )
--     end
--   end,
-- })
--

-- TODO: this
-- -- Enter git commits in insert mode
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "gitcommit",
--   callback = function()
--     vim.api.nvim_create_autocmd("VimEnter", {
--       callback = function() vim.cmd("startinsert") end,
--     })
--   end,
-- })
--

-- TODO: on last buffer close, open a fullscreen tree instead of a new '-' empty buffer

-- TODO: Do we need this
-- Telescope function to replace files on `<CR>`, or run default action when not opening files
-- function M.on_enter(telescope)
--   local actions = require("telescope.actions")
--   local state = require("telescope.actions.state")
--
--   -- If there is nothing to select, return
--   if not state.get_selected_entry() then return end
--
--   local filepath = state.get_selected_entry().value
--
--   -- If filepath is a string
--   if type(filepath) == "string" then
--     -- Split the filepath into path, line, and possibly column
--     local parts = h.split(filepath, ":")
--     local file_path = parts[1]
--     local line = parts[2]
--     local col = parts[3] or 0
--
--     -- Check if file_path is a valid path and not already open
--     if h.is_file_path(file_path) and not h.is_file_open(file_path) then
--       -- Close floats to avoid files being opened in small windows
--       h.close_floats()
--       actions.close(telescope)
--
--       -- Save the current buffer to close
--       local existing_buf = vim.api.nvim_get_current_buf()
--
--       -- Open new file and go to line and column
--       vim.api.nvim_command("edit " .. vim.fn.fnameescape(file_path))
--
--       if line and col then
--         vim.api.nvim_command("normal! " .. line .. "G" .. col .. "|")
--       end
--
--       -- Close that old current buffer afterwards
--       if h.buf_exists(existing_buf) then
--         vim.api.nvim_buf_delete(existing_buf, { force = false })
--       end
--
--       -- Exit if handled
--       return
--     end
--   end
--
--   -- Default action if conditions not met
--   actions.select_default(telescope)
-- end
--
