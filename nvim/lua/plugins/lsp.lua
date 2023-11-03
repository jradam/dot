return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "jose-elias-alvarez/typescript.nvim",
    "folke/neodev.nvim",
    { "j-hui/fidget.nvim", tag = "legacy", opts = {} },
  },
  opts = {
    diagnostics = {
      virtual_text = false,
      underline = true,
      float = { border = "rounded" },
    },
    servers = {
      lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } } } } },

      -- TODO implement some of this
      -- https://elijahmanor.com/blog/neovim-tailwindcss

      -- TODO just get rid of tsserver and use this instead!
      -- https://github.com/pmizio/typescript-tools.nvim
      tsserver = {
        on_attach = function(_, bufnr)
          -- TODO this line causing crashing, 'tags not found' etc
          -- require("typescript").setup({ server = client })
          vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        end,
      },
      eslint = {},
    },
    setup = {},
  },
  keys = function()
    local function filter_actions_with_import(action)
      local title_lower = action.title:lower()
      local has_update_import = string.find(title_lower, "update import") ~= nil
      local has_add_import = string.find(title_lower, "add import") ~= nil

      return has_update_import or has_add_import
    end

    local function code_action_with_import()
      vim.lsp.buf.code_action({
        filter = filter_actions_with_import,
        apply = true,
      })
    end

    return {
      { "<localleader>o", ":LspInfo<cr>",                      desc = "open lsp" },
      { "<localleader>e", vim.diagnostic.open_float,           desc = "show errors" },
      { "<localleader>i", vim.lsp.buf.hover,                   desc = "show info" },
      { "<localleader>d", code_action_with_import,             desc = "import actions" },
      { "<localleader>a", vim.lsp.buf.code_action,             desc = "all actions" },
      { "<localleader>r", vim.lsp.buf.rename,                  desc = "rename" },
      { "<localleader>u", "<cmd>Telescope lsp_references<cr>", desc = "references" },
      {
        "<localleader>n",
        function()
          vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.WARN } })
        end,
        desc = "to next",
      },
      -- TODO typescript functions
      { "<localleader>t", ":Typescript", desc = "typescript" },
    }
  end,
  config = function(_, opts)
    vim.fn.sign_define("DiagnosticSignError", { numhl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { numhl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { numhl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { numhl = "DiagnosticSignHint" })

    -- TODO Issues from here down

    vim.diagnostic.config(opts.diagnostics)

    local servers = opts.servers

    local cmp = require("cmp_nvim_lsp")
    local cap = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

    local function setup(server)
      local server_opts = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(cap),
      }, servers[server] or {})

      if opts.setup[server] then
        if opts.setup[server](server, server_opts) then
          return
        end
      elseif opts.setup["*"] then
        if opts.setup["*"](server, server_opts) then
          return
        end
      end
      require("lspconfig")[server].setup(server_opts)
    end

    local have_mason, mlsp = pcall(require, "mason-lspconfig")
    local available = have_mason and mlsp.get_available_servers() or {}

    local ensure_installed = {}
    for server, server_opts in pairs(servers) do
      if server_opts then
        server_opts = server_opts == true and {} or server_opts
        if server_opts.mason == false or not vim.tbl_contains(available, server) then
          setup(server)
        else
          ensure_installed[#ensure_installed + 1] = server
        end
      end
    end

    if have_mason then
      mlsp.setup({ ensure_installed = ensure_installed })
      mlsp.setup_handlers({ setup })
    end

    -----------------------------------------------------------------------

    -- TODO How do we get Typescript capabilities working? Organise imports etc
    -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
    -- require("typescript").setup({
    --   server = {
    --     on_attach = function(client, bufnr)
    --       vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    --     end,
    --     capabilities = capabilities,
    --   },
    -- })
    --
  end,
}
