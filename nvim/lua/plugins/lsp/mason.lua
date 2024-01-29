return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      -- Language servers
      ensure_installed = {
        "eslint",
        "jsonls",
        "lua_ls",
        "pyright",
        "tailwindcss",
      },
    })
    require("mason-tool-installer").setup({
      -- Formatters
      ensure_installed = {
        "autopep8",
        "prettierd",
        "stylua",
      },
    })
  end,
}
