return {
  "numToStr/Comment.nvim",
  dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
  config = function()
    require("ts_context_commentstring").setup({ enable_autocmd = false })

    -- TODO: this is possibly no longer required https://github.com/neovim/neovim/pull/28176

    local integration =
      require("ts_context_commentstring.integrations.comment_nvim")
    require("Comment").setup({
      pre_hook = integration.create_pre_hook(),
    })
  end,
}
