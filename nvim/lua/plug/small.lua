return {
  {
    "echasnovski/mini.move",
    opts = { mappings = { left = "H", right = "L", down = "J", up = "K" } }
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
  { "levouh/tint.nvim",       opts = { tint = -20, saturation = 0.2 } },
  { 'Aasim-A/scrollEOF.nvim', event = { 'CursorMoved', 'WinScrolled' }, opts = {} },
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
  }
}
