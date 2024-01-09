return {
	"stevearc/conform.nvim",
	opts = function()
		-- Fixes issue with default XDG_RUNTIME_DIR being inaccessible
		local XDG_RUNTIME_DIR = os.getenv("HOME") .. "/.temp-conform"

		-- Toggle formatting on save
		vim.g.should_format = true
		vim.keymap.set("n", "<leader>W", function()
			vim.g.should_format = not vim.g.should_format
			print("Formatting set to " .. tostring(vim.g.should_format))
		end, { desc = "Toggle format" })

		-- JavaScript formatting function
		local function javascript()
			local eslintrc_files = vim.fn.glob(vim.fn.getcwd() .. "/.eslintrc*", false, true)

			if #eslintrc_files > 0 then
				return { "prettierd", "eslint_d" }
			else
				return { "prettierd" }
			end
		end

		-- TypeScript formatting function
		local function typescript()
			vim.cmd("TSToolsOrganizeImports")
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
			format_on_save = function()
				if vim.g.should_format then
					return { lsp_fallback = true } -- Attempt LSP format if no formatters available
				end
			end,
			formatters = {
				prettierd = {
					env = {
						XDG_RUNTIME_DIR = XDG_RUNTIME_DIR,
						PRETTIERD_DEFAULT_CONFIG = vim.fn.expand(
							os.getenv("HOME") .. "/.config/nvim/.config/.prettierrc.json"
						),
					},
				},
				eslint_d = {
					env = {
						XDG_RUNTIME_DIR = XDG_RUNTIME_DIR,
					},
				},

				-- TODO Set up eslint formatting (and LSP?) to use own config if none found
				-- https://github.com/3rd/linter
			},
		}
	end,
}
