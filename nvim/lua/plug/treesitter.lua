return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function ()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { 'lua' }, -- lua can't be auto-installed
      auto_install = true,
    })
  end
}
