-- NOTE: Keys for this in Spyglass

return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  config = function()
    vim.keymap.set(
      "n",
      "<leader>d", -- TODO: rebind what was <leader>d before
      function()
        require("spyglass").spy("TS Tools", {
          { label = "Add imports", cmd = "TSToolsAddMissingImports" },
          { label = "Organise imports", cmd = "TSToolsOrganizeImports" },
          { label = "Rename file", cmd = "TSToolsRenameFile" },
          { label = "Fix all", cmd = "TSToolsFixAll" },
          { label = "Remove unused", cmd = "TSToolsRemoveUnused" },
          { label = "Go to definition", cmd = "TSToolsGoToSourceDefinition" },
          { label = "File references", cmd = "TSToolsFileReferences" },
        })
      end,
      { desc = "TS Tools" }
    )

    require("typescript-tools").setup({
      settings = {
        tsserver_plugins = {
          "@styled/typescript-styled-plugin",
        },
        -- jsx_close_tag = {
        --   enable = true,
        --   filetypes = { "javascriptreact", "typescriptreact" },
        -- },
      },
    })
  end,
}
