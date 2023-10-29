return {
  "akinsho/toggleterm.nvim",
  opts = function()
    return {
      on_open = function()
        vim.cmd("startinsert!")
      end,
      persist_mode = false,
      direction = "float",
      float_opts = {
        border = "curved",
        winblend = 5,
        width = math.floor(vim.api.nvim_win_get_width(0) * 1),
        height = math.floor(vim.api.nvim_win_get_height(0) * 1) - 1,
      },
    }
  end,
  init = function()
    local c = require("dracula").colors()
    local Terminal = require("toggleterm.terminal").Terminal

    local genterm, runterm, lazygit

    local function close_all_except(except_term)
      for _, term in ipairs({ genterm, runterm, lazygit }) do
        if term ~= except_term and term:is_open() then
          term:close()
        end
      end
    end

    -------------------------------------- TERM
    genterm = Terminal:new({
      highlights = {
        NormalFloat = {
          guibg = "#15161C",
        },
        FloatBorder = {
          guifg = c.green,
          guibg = "#18191F",
        },
      },
    })

    function Toggle_genterm()
      close_all_except(genterm)
      genterm:toggle()
    end

    vim.keymap.set({ "n", "t" }, "<c-t>", "<cmd>lua Toggle_genterm()<CR>", {
      desc = "terminal",
      silent = true,
    })

    -------------------------------------- RUNTERM
    runterm = Terminal:new({
      highlights = {
        NormalFloat = {
          guibg = "#15161C",
        },
        FloatBorder = {
          guifg = c.red,
          guibg = "#18191F",
        },
      },
    })

    function Toggle_runterm()
      close_all_except(runterm)
      runterm:toggle()
    end

    vim.keymap.set({ "n", "t" }, "<c-y>", "<cmd>lua Toggle_runterm()<CR>", {
      desc = "runterm",
      silent = true,
    })

    -------------------------------------- LAZYGIT
    lazygit = Terminal:new({
      cmd = "lazygit",
      hidden = true,
      float_opts = {
        border = "none",
        winblend = 0,
        width = math.floor(vim.api.nvim_win_get_width(0) * 1),
        height = math.floor(vim.api.nvim_win_get_height(0) * 1),
      },
    })

    function Toggle_lazygit()
      close_all_except(lazygit)
      lazygit:toggle()
    end

    vim.keymap.set({ "n", "t" }, "<c-g>", "<cmd>lua Toggle_lazygit()<CR>", {
      desc = "lazygit",
      silent = true,
    })
  end,
}
