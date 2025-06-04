-- https://www.reddit.com/r/neovim/comments/1jw0zav/psa_heres_a_quick_guide_to_using_the_new_built_in/
-- https://github.com/ruicsh/nvim-config/tree/main/lsp

return {
  { "mason-org/mason.nvim", opts = {} }, -- Get language servers as required
  { "j-hui/fidget.nvim", opts = {} }, -- Show loading state of LSPs
  {
    "nvim-treesitter/nvim-treesitter", -- Highlighting
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua" },
        auto_install = true,
        highlight = { enable = true },
      })
    end,
  },
  {
    "folke/lazydev.nvim", -- Set up Lua for Neovim development
    config = function() -- Co-opt lazydev config to setup LSPs
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
          },
        },
      })

      -- Enable LSPs found in /lsp/
      local lsp_configs = {}
      for _, f in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
        local server_name = vim.fn.fnamemodify(f, ":t:r")
        table.insert(lsp_configs, server_name)
      end
      vim.lsp.enable(lsp_configs)
    end,
  },
  {
    "saghen/blink.cmp", -- Completion
    version = "1.*",
    opts = {
      completion = { ghost_text = { enabled = true } },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
        },
      },
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
    },
  },
  {
    "stevearc/conform.nvim", -- Format on save
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd", "eslint_d" },
        javascriptreact = { "prettierd", "eslint_d" },
        typescript = { "prettierd", "eslint_d" },
        typescriptreact = { "prettierd", "eslint_d" },
      },
      format_on_save = { lsp_format = "fallback", timeout_ms = 1000 },
      formatters = {
        stylua = {
          command = "stylua",
          args = {
            "--config-path",
            vim.fn.stdpath("config") .. "/env/.stylua.toml",
            "-",
          },
        },
        prettierd = {
          env = {
            XDG_RUNTIME_DIR = os.getenv("HOME") .. "/.temp-conform",
            PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath("config")
              .. "/env/.prettierrc",
          },
        },
      },
    },
  },
}
