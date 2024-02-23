return {
  "vim-python/python-syntax",
  -- TODO: is there not something I can install from Mason for this?
  config = function() vim.cmd([[let g:python_highlight_all = 1]]) end,
}
