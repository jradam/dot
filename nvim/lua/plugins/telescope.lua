return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope", -- Needed for calling this from other plugins
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-symbols.nvim" },
	opts = function()
		local function on_enter(bufnr)
			-- Close floats to avoid files being opened in small windows
			require("helpers").close_floats()
			require("telescope.actions").select_default(bufnr)
		end

		-- TODO: should there be a key to quit telescope immediately, even in insert mode?

		return {
			pickers = {
				find_files = {
					-- Search hidden/dotfiles but not git files
					find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
				},
			},

			defaults = {
				initial_mode = "normal",
				layout_strategy = "vertical",
				layout_config = {
					height = 100,
					width = 100,
					scroll_speed = 9,
					mirror = true,
					-- TODO: Causes crashing with Easypick, but want to remove Easypick anyway
					-- preview_height = 0.65,
					preview_cutoff = 30, -- If window too small, don't show preview
				},
				file_ignore_patterns = { "node_modules", "yarn.lock" },
				-- TODO: make enter replace buffer and e open in new like the tree?
				-- ["<cr>"] = actions.select_default,
				-- ["e"] = actions.select_default,
				-- ["d"] = actions.delete_buffer,
				-- ["q"] = actions.close,

				mappings = {
					i = { ["<CR>"] = on_enter },
					n = { ["<CR>"] = on_enter },
				},
			},
		}
	end,
	keys = function()
		local status, builtin = pcall(require, "telescope.builtin")
		if not status then
			return
		end

		return {
			{
				"<leader>f",
				function()
					builtin.find_files({ initial_mode = "insert" })
				end,
				desc = "Find file",
			},
			{
				"<leader>s",
				function()
					builtin.live_grep({ initial_mode = "insert" })
				end,
				desc = "Find string",
			},
			{
				"<leader>t",
				":TodoTelescope<CR>",
				desc = "Find todo",
			},
			{ "<leader>l", ":TodoTelescope keywords=", desc = "Filter todo" },
			{
				"<leader>b",
				function()
					builtin.buffers()
				end,
				desc = "View buffers",
			},
			{
				"<leader>d",
				function()
					builtin.diagnostics({
						severity = { min = vim.diagnostic.severity.WARN },
					})
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>h",
				function()
					builtin.help_tags({ initial_mode = "insert" })
				end,
				desc = "Get help",
			},
			{
				"<leader>r",
				function()
					builtin.resume({ initial_mode = "normal" })
				end,
				desc = "Resume find",
			},
			{
				"<leader>n",
				function()
					builtin.symbols({ initial_mode = "insert" })
				end,
				desc = "Insert symbol",
			},
			{
				"<localleader>k",
				function()
					require("utilities").ts_quickfix()
					builtin.quickfix()
				end,
				desc = "TS issue list",
			},
		}
	end,
}
