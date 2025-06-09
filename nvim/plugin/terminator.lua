local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function open_floating_window(opts)
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local config = {
    relative = "editor",
    width = vim.o.columns,
    height = vim.o.lines - 3,
    row = 0,
    col = 0,
    style = "minimal",
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, config)

  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#50fa7b" })

  return { buf = buf, win = win }
end

vim.api.nvim_create_user_command("Terminator", function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = open_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then vim.cmd.term() end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end, {})

vim.keymap.set("n", "<C-3>", ":Terminator<cr>", { desc = "Terminator" })
