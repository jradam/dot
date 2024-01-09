return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = function()
		local function on_enter(bufnr)
			-- Close floats to avoid files being opened in small windows
			require("helpers").close_floats()
			require("telescope.actions").select_default(bufnr)
		end

		return {
			defaults = {
				initial_mode = "normal",
				layout_strategy = "vertical",
				layout_config = {
					height = 100,
					width = 100,
					scroll_speed = 9,
					mirror = true,
					preview_height = 0.6,
					preview_cutoff = 30, -- If window too small, don't show preview
				},
				file_ignore_patterns = { "node_modules", "yarn.lock" },
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

		-- TODO Menu for LSP actions/TSTools - maybe https://github.com/octarect/telescope-menu.nvim

		-- TODO Open list of Buffers with Git changes

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
			{
				"<leader>r",
				function()
					builtin.resume({ initial_mode = "normal" })
				end,
				desc = "Resume find",
			},
		}
	end,
}
