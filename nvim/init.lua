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
vim.opt.scrolloff = 8
vim.opt.showbreak = "↪ "

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

-- FIXME: this broken!
-- No more helpfiles opening in splits. No more tabs either.
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function(event)
    local type = vim.bo[event.buf].filetype

    if type == "help" or type == "markdown" or type == "text" then
      vim.bo.buflisted = true -- Unhide from buffer list
      vim.cmd.only() -- Put in own buffer
    end

    -- local tabs_open = vim.fn.tabpagenr("$")
    -- local file_path = vim.fn.bufname(event.buf)

    -- -- If a tab has appeared, close it and re-open the file normally
    -- if tabs_open > 1 then
    --   vim.defer_fn(function()
    --     vim.cmd("tabclose")
    --     vim.cmd("edit " .. file_path)
    --   end, 10) -- Delay allows state to stabilise after tab open. Fixes bug where all buffers unfocus.
    -- end
  end,
})

require("lazy").setup({
  spec = { { import = "plug" } },
  install = { colorscheme = { "dracula" } },
  change_detection = { notify = false },
})
