return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-symbols.nvim",
		},
		keys = function()
			-- `builtin` cannot be accessed until telescope is installed
			local status, builtin = pcall(require, "telescope.builtin")
			if not status then
				return
			end

			local ins = { initial_mode = "insert" }
			local nor = { initial_mode = "normal" }

			return {
				{
					"<leader>f",
					function()
						builtin.find_files(ins)
					end,
					desc = "find files",
				},
				{
					"<leader>s",
					function()
						builtin.live_grep(ins)
					end,
					desc = "find string",
				},
				{
					"<leader>b",
					function()
						builtin.buffers()
					end,
					desc = "view buffers",
				},
				{
					"<leader>h",
					function()
						builtin.help_tags(ins)
					end,
					desc = "get help",
				},
				{
					"<leader>d",
					function()
						builtin.diagnostics({
							severity = { min = vim.diagnostic.severity.WARN },
						})
					end,
					desc = "diagnostics",
				},
				-- TODO add `yarn lint` to this too
				{
					"<leader>k",
					function()
						-- local function append_to_quickfix(makeprg, format)
						--   local current_qflist = vim.fn.getqflist()
						--
						--   vim.api.nvim_command("setlocal makeprg=" .. makeprg)
						--   vim.api.nvim_command(":silent make")
						--   local new_qflist = vim.fn.getqflist()
						--
						--   local combined_qflist = vim.list_extend(current_qflist, new_qflist)
						--   vim.fn.setqflist({}, " ", { items = combined_qflist })
						-- end

						if vim.bo.filetype == "typescriptreact" or vim.bo.filetype == "typescript" then
							vim.api.nvim_command(":echo '/// LOADING /// LOADING /// LOADING ///'")

							vim.api.nvim_command("compiler tsc | setlocal makeprg=npx\\ tsc")
							vim.api.nvim_command(":silent make")

							-- append_to_quickfix("npx\\ tsc\\ --strict")
							-- append_to_quickfix("yarn\\ lint\\ --format\\ unix")
						end
						builtin.quickfix()
					end,
					desc = "quick fix",
				},
				{ "<leader>t", ":TodoTelescope<cr>", desc = "view todo" },
				{ "<leader>l", ":TodoTelescope keywords=", desc = "filter todo" },
				-- TODO write a custom toggle (or does one exist on builtin?) so can toggle with CTRL like the terminal regardless of insert mode
				{
					"<leader>r",
					function()
						builtin.resume(nor)
					end,
					desc = "resume",
				},
				{
					-- for inserting icons
					"<leader>n",
					function()
						builtin.symbols(ins)
					end,
					desc = "insert symbol",
				},
			}
		end,
		opts = function()
			local actions = require("telescope.actions")

			return {
				pickers = {
					find_files = {
						-- search hidden/dotfiles but not git files
						find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
					},
				},
				defaults = {
					mappings = {
						n = {
							-- TODO make enter replace buffer
							["<cr>"] = actions.select_default,
							["e"] = actions.select_default,
							["d"] = actions.delete_buffer,
							["q"] = actions.close,
						},
					},
					initial_mode = "normal",
					layout_strategy = "vertical",
					layout_config = {
						height = 100,
						width = 100,
						scroll_speed = 9,
						mirror = true,
						preview_cutoff = 0,
						preview_height = 0.7,
					},
					file_ignore_patterns = { "node_modules", "yarn.lock" },
				},
			}
		end,
	},
}
