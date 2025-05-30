local o = vim.opt

-- Line numbers
o.number = true
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
o.showmode = false
o.termguicolors = true

-- Search settings
o.ignorecase = true
o.smartcase = true

-- Line breaks
o.linebreak = true
o.showbreak = "↪ "

-- Behaviour
o.scrolloff = 8

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

-- Send `<Esc>` on focus loss to enter normal mode (when not terminal)
vim.api.nvim_create_autocmd("FocusLost", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype ~= "terminal" then
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
        "n",
        true
      )
    end
  end,
})

-- TODO: make into small plugin
-- No more helpfiles opening in splits. No more tabs either.
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function(event)
    local type = vim.bo[event.buf].filetype

    if type == "help" or type == "markdown" or type == "text" then
      vim.bo.buflisted = true -- Unhide from buffer list
      vim.cmd.only() -- Put in own buffer
    end

    local tabs_open = vim.fn.tabpagenr("$")
    local file_path = vim.fn.bufname(event.buf)

    -- If a tab has appeared, close it and re-open the file normally
    if tabs_open > 1 then
      vim.defer_fn(function()
        vim.cmd("tabclose")
        vim.cmd("edit " .. file_path)
      end, 10) -- Delay allows state to stabilise after tab open. Fixes bug where all buffers unfocus.
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
  callback = function() vim.highlight.on_yank() end,
  pattern = "*",
})

-- Enter git commits in insert mode
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function() vim.cmd("startinsert") end,
    })
  end,
})
