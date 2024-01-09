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

		-- TODO Telescope should close nvim-tree (or all floats?) when opening

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
