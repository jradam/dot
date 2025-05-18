return {
  "akinsho/toggleterm.nvim",
  opts = function()
    return {
      float_opts = {
        border = "curved",
        width = math.floor(vim.api.nvim_win_get_width(0)),
        height = math.floor(vim.api.nvim_win_get_height(0)) - 1,
      },
      size = function(term)
        if term.direction == "horizontal" then
          return 10
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.3
        end
      end,
    }
  end,
  init = function()
    -- Enter insert mode when terminal gets focus
    vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
      pattern = { "term://*" },
      callback = function()
        local timer = vim.loop.new_timer()
        timer:start(
          10,
          0,
          vim.schedule_wrap(function()
            if vim.bo.buftype == "terminal" then vim.cmd("startinsert!") end
          end)
        )
      end,
    })

    local c = require("dracula").colors()
    local darkBg = "#15161C"
    local Terminal = require("toggleterm.terminal").Terminal

    local terminal_one = Terminal:new({
      direction = "float",
      highlights = {
        NormalFloat = { guibg = darkBg },
        FloatBorder = { guifg = c.green, guibg = darkBg },
      },
    })
    local terminal_two = Terminal:new({
      direction = "float",
      highlights = {
        NormalFloat = { guibg = darkBg },
        FloatBorder = { guifg = c.red, guibg = darkBg },
      },
    })
    local terminal_three = Terminal:new({
      direction = "float",
      cmd = "claude",
      highlights = {
        NormalFloat = { guibg = darkBg },
        FloatBorder = { guifg = c.bright_blue, guibg = darkBg },
      },
      on_close = function() vim.cmd("checktime") end, -- Refresh all open buffers to get changes
    })
    local terminal_horizontal = Terminal:new({ direction = "horizontal" })
    local terminal_vertical = Terminal:new({ direction = "vertical" })

    local function Toggle_terminal_horizontal() terminal_horizontal:toggle() end
    local function Toggle_terminal_vertical() terminal_vertical:toggle() end
    local function Toggle_terminal_one() terminal_one:toggle() end
    local function Toggle_terminal_two() terminal_two:toggle() end
    local function Toggle_terminal_three() terminal_three:toggle() end

    vim.keymap.set(
      { "n", "t" },
      "1",
      function() Toggle_terminal_horizontal() end,
      { desc = "Terminal horizontal" }
    )
    vim.keymap.set(
      { "n", "t" },
      "2",
      function() Toggle_terminal_vertical() end,
      { desc = "Terminal vertical" }
    )
    vim.keymap.set(
      { "n", "t" },
      "3",
      function() Toggle_terminal_one() end,
      { desc = "Terminal one" }
    )
    vim.keymap.set(
      { "n", "t" },
      "4",
      function() Toggle_terminal_two() end,
      { desc = "Terminal two" }
    )
    vim.keymap.set(
      { "n", "t" },
      "5",
      function() Toggle_terminal_three() end,
      { desc = "Terminal three" }
    )
  end,
}
