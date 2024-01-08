return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  opts = {
    diagnostics = {
      virtual_text = false,
      float = { border = "rounded" },
    }
  },
  keys = function()
    return {
      { "<localleader>i", vim.lsp.buf.hover, desc = "Show info" },
      { "<localleader>e", vim.diagnostic.open_float, desc = "Show errors" },
      { "<localleader>r", vim.lsp.buf.rename, desc = "Rename" },
      { "<localleader>p", vim.diagnostic.goto_prev, desc = "Go to previous" },
      { "<localleader>n", vim.diagnostic.goto_next, desc = "Go to next" },
    }
  end,
  config = function(_, opts)
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- Change the numberline icons to colour highlights
    for _, type in ipairs({ "Error", "Warn", "Hint", "Info" }) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text="", numhl = hl })
    end

    vim.diagnostic.config(opts.diagnostics)

    local capabilities = cmp_nvim_lsp.default_capabilities()

    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      -- Make language server recognize "vim" global
      settings = { Lua = { diagnostics = { globals = { "vim" } } } },
    })
  end
}
