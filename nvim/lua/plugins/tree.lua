return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "<leader>e", ":NvimTreeToggle<CR>", desc = "explorer", silent = true },
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

			-- TODO Close on `<Esc>`
			-- TODO Git colours don't update/reset to white after commit etc

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
				relativenumber = true,
				signcolumn = "no",
				adaptive_size = true,
				float = {
					enable = true,
					open_win_config = {
						height = math.floor(vim.api.nvim_win_get_height(0) * 1) - 2,
						row = 0,
						col = 0,
					},
				},
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
			renderer = {
				highlight_git = true,
				icons = {
					-- Hides the git icons, as `signcolumn` is not shown
					git_placement = "signcolumn",
				},
			},
			filters = {
				-- Don't show git files in the tree
				custom = { "^.git$" },
			},
			git = {
				show_on_open_dirs = false,
			},
		}
	end,
	init = function()
		local function open_on_startup(data)
			-- If we are starting in a file, do not open the tree
			if not vim.fn.isdirectory(data.file) == 1 then
				return
			end

			-- If a float is open on startup, do not open the tree
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local config = vim.api.nvim_win_get_config(win)
				if config.relative ~= "" then
					return
				end
			end

			require("nvim-tree.api").tree.open()
		end

		vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_on_startup })
	end,
}
