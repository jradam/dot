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
          return vim.o.columns * 0.4
        end
      end,
    }
  end,
  init = function()
    local c = require("dracula").colors()
    local darkBg = "#15161C"
    local Terminal = require("toggleterm.terminal").Terminal

    local terminal_one = Terminal:new({
      direction = "float",
      highlights = {
        NormalFloat = { guibg = darkBg },
        FloatBorder = { guifg = c.green, guibg = darkBg },
      },
      on_close = function() vim.cmd("checktime") end, -- Refresh all open buffers to get changes
    })
    local terminal_two = Terminal:new({
      direction = "float",
      highlights = {
        NormalFloat = { guibg = darkBg },
        FloatBorder = { guifg = c.red, guibg = darkBg },
      },
      on_close = function() vim.cmd("checktime") end, -- Refresh all open buffers to get changes
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
    local terminal_split = Terminal:new({ direction = "horizontal" })

    local function Toggle_terminal_one() terminal_one:toggle() end
    local function Toggle_terminal_two() terminal_two:toggle() end
    local function Toggle_terminal_three() terminal_three:toggle() end
    local function Toggle_terminal_split() terminal_split:toggle() end

    vim.keymap.set(
      { "n", "t" },
      "<C-t>",
      function() Toggle_terminal_one() end,
      { desc = "Terminal one" }
    )
    vim.keymap.set(
      { "n", "t" },
      "<C-y>",
      function() Toggle_terminal_two() end,
      { desc = "Terminal two" }
    )
    vim.keymap.set(
      { "n", "t" },
      "<C-e>",
      function() Toggle_terminal_three() end,
      { desc = "Terminal three" }
    )
    vim.keymap.set(
      { "n", "t" },
      "<C-s>",
      function() Toggle_terminal_split() end,
      { desc = "Terminal split" }
    )
  end,
}
