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

    -- Change the numberline error icons to colour highlights
    for _, type in ipairs({ "Error", "Warn", "Hint", "Info" }) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = "", numhl = hl })
    end

    -- Apply styling options for diagnostics and hovers
    vim.diagnostic.config(opts.diagnostics)

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
      tailwindcss = {
        capabilities = capabilities,
        -- tailwindcss hover sending back incorrectly formatted response, this fixes it
        on_attach = function(client, bufnr)
          local original = vim.lsp.buf.hover -- Store original hover result
          vim.lsp.buf.hover = function(settings)
            settings = settings or {}
            local position = vim.lsp.util.make_position_params()

            client.request("textDocument/hover", position, function(_, result)
              if result and result.contents and result.contents.value then
                -- It's a Tailwind result, handle it specially
                vim.lsp.util.open_floating_preview(
                  vim.split(result.contents.value, "\n"),
                  result.contents.language,
                  settings
                )
              else
                -- Not a Tailwind result, use original hover
                original(settings)
              end
            end, bufnr)
          end
        end,
        root_dir = function(fname)
          local find_root = lspconfig.util.root_pattern

          -- Check for tailwind config files
          local root_dir = find_root("tailwind.config*")(fname)
          if root_dir then return root_dir end

          -- Check for vite config that contains the word "tailwind"
          local vite_root = find_root("vite.config.ts")(fname)
          if vite_root then
            -- Read vite config file
            local vite_config_path =
              table.concat({ vite_root, "vite.config.ts" }, "/")
            local file = io.open(vite_config_path, "r")
            if file then
              local content = file:read("*all")
              file:close()
              -- Check if content contains "tailwind"
              if content:match("tailwind") then return vite_root end
            end
          end

          return nil -- If no config found, don't start
        end,
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                -- classes="..." or '...' or `...`
                "classes\\s*=\\s*['\"`]([^'\"`,]*)['\"`]",
                -- className="..." or '...' or `...`
                "className\\s*=\\s*['\"`]([^'\"`,]*)['\"`]",
              },
            },
          },
        },
      },
    }

    for server, config in pairs(servers) do
      lspconfig[server].setup(config)
    end
  end,
}
