return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    sections = {
      lualine_b = { "branch", "diff" },
      lualine_c = { "diagnostics" },
      lualine_x = { "filetype" },
    },
    extensions = { "nvim-tree" },
  },
}
