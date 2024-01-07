return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>e", ":NvimTreeToggle<CR>", desc = "explorer" },
  },
  opts = function()
    local api = require("nvim-tree.api")
    local toggle = 0

    local function multi(node)
      if node.type == nil then
	if toggle == 0 then
	  api.tree.expand_all()
	  toggle = 1
	else
	  api.tree.collapse_all()
	  toggle = 0
	end
      else
	api.node.open.edit()
      end
    end

    local function open_in_same()
      local node = api.tree.get_node_under_cursor()
      if node and node.type == "file" then
	local current_buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_command("bdelete " .. current_buf)
	vim.api.nvim_command("edit " .. node.absolute_path)
      end
    end

    local function on_attach(bufnr)
      local function opts(desc)
	return { desc = desc, buffer = bufnr }
      end

      -- Custom
      vim.keymap.set("n", "<CR>", open_in_same, opts("Open"))
      vim.keymap.set("n", "e", function() 
	multi(api.tree.get_node_under_cursor()) 
	end, opts("Multi"))

      -- Defaults
      vim.keymap.set("n", "a", api.fs.create, opts("Create"))
      vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
      vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
      vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
      vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
      vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
    end

    return { 
      on_attach = on_attach,
      view = {
	signcolumn = "no",
      },
      actions = {
	expand_all = {
	  max_folder_discovery = 600,
	  exclude = {
	    "node_modules",
	    ".git",
	    ".next",
	    ".storybook",
	    "dist",
	    "build",
	    ".local",
	    ".config",
	  },
	},
	change_dir = { restrict_above_cwd = true },
	open_file = { quit_on_open = true },
      },
    }
  end,
}
