return {
  { "mason-org/mason.nvim", opts = {} }, -- Get language servers as required
  { "j-hui/fidget.nvim", opts = {} }, -- Show loading state of LSPs
  { "folke/lazydev.nvim", opts = {} }, -- Better Lua LSP support
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
    "saghen/blink.cmp", -- Completion
    version = "1.*",
    opts = {
      completion = { ghost_text = { enabled = true } },
      cmdline = { keymap = { ["<CR>"] = { "accept", "fallback" } } },
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
