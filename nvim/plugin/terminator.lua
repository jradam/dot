local state = { terminals = {} }

local function create_terminal_window(opts)
  local buf = vim.api.nvim_buf_is_valid(opts.buf) and opts.buf
      or vim.api.nvim_create_buf(false, true)

  local border_hl = "TermBorder" .. opts.index
  vim.api.nvim_set_hl(0, border_hl, { fg = opts.color, bg = "#282A36" })

  local config = {
    relative = "editor",
    width = vim.o.columns,
    height = vim.o.lines - 3,
    row = 0,
    col = 0,
    style = "minimal",
    border = {
      { "╭", border_hl },
      { "─", border_hl },
      { "╮", border_hl },
      { "│", border_hl },
      { "╯", border_hl },
      { "─", border_hl },
      { "╰", border_hl },
      { "│", border_hl },
    },
  }
  local win = vim.api.nvim_open_win(buf, true, config)
  return { buf = buf, win = win }
end

local function toggle_terminal(index, color, startup_cmd)
  index = index or 1

  state.terminals[index] = state.terminals[index] or { buf = -1, win = -1 }
  local terminal = state.terminals[index]

  if not vim.api.nvim_win_is_valid(terminal.win) then
    -- Close other terminals before opening this one
    for i, term in pairs(state.terminals) do
      if i ~= index and vim.api.nvim_win_is_valid(term.win) then
        vim.api.nvim_win_hide(term.win)
      end
    end

    terminal = create_terminal_window({
      buf = terminal.buf,
      color = color,
      index = index,
    })
    state.terminals[index] = terminal

    if vim.bo[terminal.buf].buftype ~= "terminal" then
      if startup_cmd then
        vim.cmd.term(startup_cmd)
      else
        vim.cmd.term()
      end
    end

    vim.bo[terminal.buf].buflisted = false
    vim.cmd.startinsert()
  else
    vim.api.nvim_win_hide(terminal.win)
    vim.cmd("checktime") -- Refresh buffers on close
  end
end

vim.keymap.set(
  { "n", "t" },
  "<C-e>",
  function() toggle_terminal(1, "#50fa7b") end,
  { desc = "Scratch" }
)
vim.keymap.set(
  { "n", "t" },
  "<C-t>",
  function() toggle_terminal(2, "#FF5555") end,
  { desc = "Run" }
)
vim.keymap.set(
  { "n", "t" },
  "<C-y>",
  function() toggle_terminal(3, "#FFB86C", "claude") end,
  { desc = "Claude" }
)
