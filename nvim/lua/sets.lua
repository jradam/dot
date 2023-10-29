local o = vim.opt

-- line numbers
o.relativenumber = true
o.number = true
o.numberwidth = 3

-- space at bottom if hold `j` down
o.scrolloff = 12

-- indentation
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

-- appearance
o.termguicolors = true
o.signcolumn = "number"

-- hide mode from command line
o.showmode = false

-- line breaks
o.linebreak = true
o.showbreak = "↪ "

-- no swapfiles
o.swapfile = false

-- persistent undo
o.undodir = os.getenv("HOME") .. "/.nvim-undodir"
o.undofile = true

-- timeout for leader key, which-key
o.timeoutlen = 500
-- timeout for interactivity, including local-highlight
o.updatetime = 1000

-- search settings
o.ignorecase = true
o.smartcase = true

-- no comment continuation on `enter`
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  command = [[ setlocal formatoptions-=cro ]],
})

-- enter normal mode on focus loss, unless we are in a terminal
vim.api.nvim_create_autocmd("FocusLost", {
  pattern = "*",
  command =
  "lua (function() if vim.api.nvim_buf_get_option(0, 'buftype') ~= 'terminal' then vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true) end end)()",
})

-- spelling for markdown files
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.md",
  command = [[ setlocal spell ]],
})

-- open help in new buffer
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function(event)
    local type = vim.bo[event.buf].filetype

    if type == "help" or type == "markdown" then
      vim.bo.buflisted = true -- unhide help from buffer list
      vim.cmd.only()       -- put in new buffer
    end
  end,
})
