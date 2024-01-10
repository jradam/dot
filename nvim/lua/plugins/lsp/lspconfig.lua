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
		hover = { border = "rounded" },
	},
	keys = function()
		return {
			{ "<localleader>i", vim.lsp.buf.hover, desc = "Show info" },
			{ "<localleader>e", vim.diagnostic.open_float, desc = "Show errors" },
			{ "<localleader>r", vim.lsp.buf.rename, desc = "Rename" },
			{ "<localleader>p", vim.diagnostic.goto_prev, desc = "Go to previous" },
			{ "<localleader>n", vim.diagnostic.goto_next, desc = "Go to next" },
			{ "<localleader>u", "<cmd>Telescope lsp_references<CR>", desc = "List references" },
			-- TODO make these an Easypick
			{ "<localleader>d", "<cmd>TSToolsAddMissingImports<CR>", desc = "TS add imports" },
			{ "<localleader>R", "<cmd>TSToolsRenameFile<CR>", desc = "TS rename file" },
			{ "<localleader>f", "<cmd>TSToolsFixAll<CR>", desc = "TS fix all" },
			{ "<localleader>o", "<cmd>TSToolsOrganizeImports<CR>", desc = "TS organise imports" },
		}
	end,
	config = function(_, opts)
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- Change the numberline error icons to colour highlights
		for _, type in ipairs({ "Error", "Warn", "Hint", "Info" }) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = "", numhl = hl })
		end

		-- Apply styling options for diagnostics and hovers
		vim.diagnostic.config(opts.diagnostics)
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, opts.hover)

		local capabilities = cmp_nvim_lsp.default_capabilities()

		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					completion = { callSnippet = "Replace" }, -- Completion for function params
					diagnostics = { globals = { "vim" } }, -- Make lsp recognize "vim" global
				},
			},
		})

		lspconfig["tailwindcss"].setup({
			capabilities = capabilities,
		})

		-- TODO Set up eslint formatting and LSP to use own config if none found in project
		-- NOTE refine elsintrc

		-- TODO add a `yarn` in the `env/` dir to the bash install script
		-- NOTE very useful https://github.com/3rd/linter
		-- TODO make notes yellow
		lspconfig["eslint"].setup({ -- Check `:LspLog` to debug
			-- capabilities = vim.tbl_deep_extend("force", capabilities, {
			-- 	workspace = {
			-- 		didChangeWorkspaceFolders = { dynamicRegistration = true },
			-- 	},
			-- }),
			-- settings = {
			-- 	nodePath = vim.fn.stdpath("config") .. "/env/node_modules",
			-- 	options = {
			-- 		overrideConfigFile = vim.fn.stdpath("config") .. "/env/.eslintrc.json",
			-- 		resolvePluginsRelativeTo = vim.fn.stdpath("config") .. "/env/node_modules",
			-- 		useEslintrc = false, -- This prevents project-specific config
			-- 	},
			-- },
		})

		lspconfig["jsonls"].setup({
			capabilities = capabilities,
		})
	end,
}
