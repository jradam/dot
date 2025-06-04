-- https://www.reddit.com/r/neovim/comments/1jw0zav/psa_heres_a_quick_guide_to_using_the_new_built_in/
-- https://github.com/ruicsh/nvim-config/tree/main/lsp

return {
  { "mason-org/mason.nvim", opts = {} }, -- Get language servers as required
  { "j-hui/fidget.nvim",    opts = {} }, -- Show loading state of LSPs
  {
    "nvim-treesitter/nvim-treesitter",   -- Highlighting
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { 'lua' },
        auto_install = true,
        highlight = { enable = true }
      })
    end
  },
  {
    "folke/lazydev.nvim", -- Set up Lua for Neovim development
    config = function()   -- Co-opt lazydev config to setup LSPs
      require("lazydev").setup({})

      -- Number highlighting for errors
      local s = vim.diagnostic.severity
      vim.diagnostic.config({
        float = { border = "rounded" },
        signs = {
          text = { [s.ERROR] = "", [s.WARN] = "", [s.INFO] = "", [s.HINT] = "" },
          numhl = {
            [s.ERROR] = "DiagnosticSignError",
            [s.WARN] = "DiagnosticSignWarn",
            [s.INFO] = "DiagnosticSignInfo",
            [s.HINT] = "DiagnosticSignHint",
          }
        }
      })

      -- Format on save
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end
            })
          end
        end,
      })

      -- Setup LSPs in /lsp/
      local lsp_configs = {}
      for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
        local server_name = vim.fn.fnamemodify(f, ':t:r')
        table.insert(lsp_configs, server_name)
      end
      vim.lsp.enable(lsp_configs)
    end
  },
  -- TODO: Keys for this
  {
    "saghen/blink.cmp",
    version = '1.*',
    opts = {
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- make lazydev completions top priority
          },
        },
      },
    },
  }
}
