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

		return {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd", "eslint_d" },
				javascriptreact = { "prettierd", "eslint_d" },
				typescript = { "prettierd", "eslint_d" },
				typescriptreact = { "prettierd", "eslint_d" },
				json = { "prettierd" },
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
						PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath("config") .. "/env/.prettierrc.json",
					},
				},
				eslint_d = { env = { XDG_RUNTIME_DIR = XDG_RUNTIME_DIR } },
			},
		}
	end,
}
