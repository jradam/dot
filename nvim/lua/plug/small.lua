return {
  {
    "echasnovski/mini.move",
    opts = { mappings = { left = "H", right = "L", down = "J", up = "K" } },
  },
  {
    "mbbill/undotree",
    keys = { { "<leader>u", vim.cmd.UndotreeToggle, desc = "Undo tree" } },
    config = function()
      vim.g.undotree_WindowLayout = 4
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      sections = {
        lualine_b = { "branch", "diff" },
        lualine_c = { "diagnostics" },
        lualine_x = { "filetype" },
      },
    },
  },
  { "levouh/tint.nvim", opts = { tint = -20, saturation = 0.2 } },
  {
    "karb94/neoscroll.nvim",
    config = function()
      local neoscroll = require("neoscroll")
      neoscroll.setup({ stop_eof = false, duration_multiplier = 0.5 })

      vim.keymap.set("n", "<C-d>", function()
        local file_lines = vim.fn.line("$")
        local win_height = vim.fn.winheight(0) - 2 -- -2 for lualine and cmdline
        local current_line = vim.fn.line(".")

        local top_half = current_line < (win_height / 2)
        local past_halfway = current_line >= (file_lines / 2)

        if top_half and not past_halfway then
          vim.cmd("normal! M")
        else
          neoscroll.ctrl_d({ duration = 150 })
          vim.cmd("normal! zz")
        end
      end)
    end,
  },
  {
    -- "folke/todo-comments.nvim",
    dir = "~/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  {
    "tzachar/local-highlight.nvim",
    config = function()
      require("local-highlight").setup({
        disable_file_types = { "markdown" },
        hlgroup = "CursorLine",
        animate = false,
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signcolumn = false,
      numhl = true,
      preview_config = {
        border = "rounded",
        relative = "cursor",
        anchor = "SW",
        row = -1,
        col = 0,
      },
    },
  },
}
