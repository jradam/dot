return {
  "mbbill/undotree",
  keys = { { "<leader>t", vim.cmd.UndotreeToggle, desc = "Undo tree" } },
  config = function()
    vim.g.undotree_WindowLayout = 4
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
}
