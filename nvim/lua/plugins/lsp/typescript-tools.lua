return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	config = function()
		require("typescript-tools").setup({
			settings = {
				tsserver_plugins = {
					"@styled/typescript-styled-plugin",
				},
				jsx_close_tag = {
					enable = true,
					filetypes = { "javascriptreact", "typescriptreact" },
				},
			},
		})
	end,
}

-- FIXME: need to do something like this
-- local function load_typescript_tools_if_package_json_exists()
--     local path = vim.fn.getcwd() .. "/package.json"
--     if vim.fn.filereadable(path) == 1 then
--         require("typescript-tools").setup({
--             -- your existing setup configuration
--         })
--     else
--         -- Optionally, you can print a message or log this event
--         vim.api.nvim_echo({{"typescript-tools.nvim not loaded - no package.json found", "WarningMsg"}}, true, {})
--     end
-- end
--
-- return {
--     "pmizio/typescript-tools.nvim",
--     dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
--     config = load_typescript_tools_if_package_json_exists
-- }
