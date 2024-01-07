return {
  -- TODO https://youtu.be/NL8D8EkphUw?si=8gNzyEyfrxbn2s94&t=968
  "neovim/nvim-lspconfig",
  opts = { diagnostics = { virtual_text = false } },
  config = function(_, opts)
    vim.fn.sign_define("DiagnosticSignError", { numhl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { numhl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { numhl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { numhl = "DiagnosticSignHint" })

    vim.diagnostic.config(opts.diagnostics)
  end
}
