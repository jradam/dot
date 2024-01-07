return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = function()
    local status, builtin = pcall(require, "telescope.builtin")
    if not status then return end

    return {
      {
	"<leader>f",
	function()
	  builtin.find_files()
	end,
	desc = "Find files",
      },
      {
	"<leader>s",
	function()
	  builtin.live_grep()
	end,
	desc = "Find string",
      },
    }
  end,
  opts = function()
    local actions = require("telescope.actions")

    return {
      defaults = {
	layout_strategy = "vertical",
	layout_config = {
	  height = 100,
	  width = 100,
	  scroll_speed = 9,
	  mirror = true,
	  preview_height = 0.7,
	  -- If window is too small, don't show preview section
	  preview_cutoff = 30,
	},
	file_ignore_patterns = { "node_modules", "yarn.lock" },
      },
    }
  end,
}
