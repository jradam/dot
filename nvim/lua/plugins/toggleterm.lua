return {
  "akinsho/toggleterm.nvim",
  opts = function()
    return {
      on_open = function() vim.cmd("startinsert!") end,
      float_opts = {
        border = "curved",
        width = math.floor(vim.api.nvim_win_get_width(0)),
        height = math.floor(vim.api.nvim_win_get_height(0)) - 1,
      },
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      persist_size = true,
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
    })
    local terminal_two = Terminal:new({
      direction = "float",
      highlights = {
        NormalFloat = { guibg = darkBg },
        FloatBorder = { guifg = c.red, guibg = darkBg },
      },
    })
    local terminal_three = Terminal:new({ direction = "horizontal" })
    local terminal_four = Terminal:new({ direction = "vertical" })

    function Toggle_terminal_one() terminal_one:toggle() end
    function Toggle_terminal_two() terminal_two:toggle() end
    function Toggle_terminal_three() terminal_three:toggle() end
    function Toggle_terminal_four() terminal_four:toggle() end

    vim.keymap.set(
      { "n", "t" },
      "<C-t>",
      "<cmd>lua Toggle_terminal_one()<CR>",
      { desc = "Terminal one" }
    )
    vim.keymap.set(
      { "n", "t" },
      "<C-y>",
      "<cmd>lua Toggle_terminal_two()<CR>",
      { desc = "Terminal two" }
    )
    -- TODO: Have these in a telescope picker instead
    -- TODO: Need better bindings for moving between splits
    vim.keymap.set(
      { "n", "t" },
      "<C-s>",
      "<cmd>lua Toggle_terminal_three()<CR>",
      { desc = "Terminal three" }
    )
    vim.keymap.set(
      { "n", "t" },
      "<C-e>",
      "<cmd>lua Toggle_terminal_four()<CR>",
      { desc = "Terminal four" }
    )
  end,
}
