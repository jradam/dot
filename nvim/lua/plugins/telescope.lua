return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		defaults = {
			initial_mode = "normal",
			layout_strategy = "vertical",
			layout_config = {
				height = 100,
				width = 100,
				scroll_speed = 9,
				mirror = true,
				preview_height = 0.6,
				preview_cutoff = 30, -- If window too small, don't show preview section
			},
			file_ignore_patterns = { "node_modules", "yarn.lock" },
		},
	},
	keys = function()
		local status, builtin = pcall(require, "telescope.builtin")
		if not status then
			return
		end

		-- Close floats to avoid files being opened in small windows
		vim.api.nvim_create_autocmd("User", {
			pattern = "TelescopeFindPre",
			callback = function()
				for _, win in pairs(vim.api.nvim_list_wins()) do
					if vim.api.nvim_win_get_config(win).relative ~= "" then
						vim.api.nvim_win_close(win, false)
					end
				end
			end,
		})

		-- TODO Menu for LSP actions/TSTools - maybe https://github.com/octarect/telescope-menu.nvim

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
