return {
	"stevearc/conform.nvim",
	opts = function()
		local function javascript()
			local eslintrc_files = vim.fn.glob(vim.fn.getcwd() .. "/.eslintrc*", false, true)

			if #eslintrc_files > 0 then
				return { "prettierd", "eslint_d" }
			else
				return { "prettierd" }
			end
		end

		local function typescript()
			vim.cmd("TSToolsAddMissingImports")
			vim.cmd("TSToolsOrganizeImports")

			-- TODO add TSToolsFixAll to this?

			return javascript()
		end

		return {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = javascript,
				javascriptreact = javascript,
				typescript = typescript,
				typescriptreact = typescript,
			},
			format_on_save = {
				lsp_fallback = true, -- Attempt LSP formatting if no formatters available
			},
			formatters = {
				prettierd = {
					env = {
						PRETTIERD_DEFAULT_CONFIG = vim.fn.expand(
							os.getenv("HOME") .. "/.config/nvim/.config/.prettierrc.json"
						),
					},
				},
				-- TODO Set up eslint formatting (and LSP?) to use own config if none found
				-- https://github.com/3rd/linter
			},
		}
	end,
}
