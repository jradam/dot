return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { "diagnostics" },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "nvim-tree" },
    },
  },
  {
    -- TODO rewrite in lua
    dir = "~/.config/nvim/.local/bufcmd",
    config = function()
      vim.cmd([[
       let g:bufferline_show_bufnr = 0
       let g:bufferline_rotate = 2
       let g:bufferline_unmodified = ''
       let g:bufferline_fname_mod = ":t:r"
       ]])
    end,
  },
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, desc = "undo tree" },
    },
    config = function()
      vim.g.undotree_WindowLayout = 4
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({
        plugins = {
          spelling = {
            enabled = true,
            suggestions = 20,
          },
        },
      })
    end,
  },
  -- {
  --   "m4xshen/smartcolumn.nvim",
  --   opts = {
  --     colorcolumn = "100",
  --   },
  -- },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = function()
      require("fidget").setup({})
    end,
  },
}
