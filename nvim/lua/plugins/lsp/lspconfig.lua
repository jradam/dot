return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "j-hui/fidget.nvim", opts = {} }, -- Shows LSP loading status
    { "folke/neodev.nvim", opts = {} }, -- Modifies lua_ls with Neovim development help
  },
  opts = {
    diagnostics = {
      virtual_text = false,
      float = { border = "rounded" },
    },
  },
  keys = function()
    local go_prev = function()
      vim.diagnostic.goto_prev({
        severity = { min = vim.diagnostic.severity.WARN },
      })
    end
    local go_next = function()
      vim.diagnostic.goto_next({
        severity = { min = vim.diagnostic.severity.WARN },
      })
    end

    -- TODO: want any of this from kickstart?
    -- nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    -- nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    -- nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    -- nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
    -- nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    -- nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    -- nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    -- nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
    -- nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    -- nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    -- nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    -- nmap("<leader>wl", function()
    -- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, "[W]orkspace [L]ist Folders")

    return {
      {
        "<localleader>i",
        function() vim.lsp.buf.hover({ border = "rounded" }) end,
        desc = "Show info",
      },
      {
        "<localleader>e",
        vim.diagnostic.open_float,
        desc = "Show errors",
      },
      { "<localleader>r", vim.lsp.buf.rename, desc = "Rename" },
      {
        "<localleader>a",
        vim.lsp.buf.code_action,
        desc = "Code actions",
      },
      { "<localleader>p", go_prev, desc = "Go to previous" },
      { "<localleader>n", go_next, desc = "Go to next" },
      {
        "<localleader>u",
        "<cmd>Telescope lsp_references<CR>",
        desc = "List references",
      },
    }
  end,
  config = function(_, opts)
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local u = require("utilities")

    local diagnostics_config = vim.tbl_deep_extend("force", opts.diagnostics, {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "",
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
          [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
          [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
          [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
        },
      },
    })
    vim.diagnostic.config(diagnostics_config)

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

    local servers = {
      eslint = { -- Check `:LspLog` to debug
        on_attach = u.eslint_setup,
        capabilities = vim.tbl_deep_extend("force", capabilities, {
          workspace = {
            didChangeWorkspaceFolders = {
              dynamicRegistration = true,
            },
          },
        }),
        root_dir = lspconfig.util.root_pattern(".git", "package.json"),
      },
      html = {
        capabilities = vim.tbl_deep_extend("force", capabilities, {
          workspace = {
            didChangeWorkspaceFolders = {
              dynamicRegistration = true,
            },
          },
        }),
      },
      jsonls = { capabilities = capabilities },
      lua_ls = {
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" }, -- Completion for function params
            diagnostics = {
              globals = { "vim" }, -- Make lsp recognize "vim" global
            },
          },
        },
      },
      pyright = { capabilities = capabilities },
      tailwindcss = { capabilities = capabilities },
    }

    for server, config in pairs(servers) do
      lspconfig[server].setup(config)
    end
  end,
}
