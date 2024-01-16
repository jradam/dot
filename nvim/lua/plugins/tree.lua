return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = { { "<leader>e", ":NvimTreeToggle<CR>", desc = "Explorer", silent = true } },
	opts = function()
		local api = require("nvim-tree.api")
		local u = require("utilities")

		local function on_attach(bufnr)
			local function opts(desc)
				return { desc = desc, buffer = bufnr }
			end

			-- Custom
			vim.keymap.set("n", "<Tab>", u.close_unless_last, opts("Close"))
			vim.keymap.set("n", "<Esc>", u.close_unless_last, opts("Close"))
			vim.keymap.set("n", "<CR>", u.open_in_same, opts("Open"))
			vim.keymap.set("n", "e", function()
				u.multi(api.tree.get_node_under_cursor())
			end, opts("Multi"))
			vim.keymap.set("n", "d", u.safe_delete, opts("Delete"))

			-- Defaults
			vim.keymap.set("n", "a", api.fs.create, opts("Create"))
			vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
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
					quit_on_focus_loss = false, -- Avoids a startup crash when opening a float
					open_win_config = {
						height = math.floor(vim.api.nvim_win_get_height(0) * 1) - 1,
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
					},
				},
				change_dir = { restrict_above_cwd = true },
				open_file = { quit_on_open = true },
			},
			renderer = {
				highlight_git = true,
				icons = {
					git_placement = "signcolumn", -- Hides git icons, as `signcolumn` is not shown
				},
			},
			-- Keep current file highlighted, also refreshes tree so highlight_git stays updated
			update_focused_file = { enable = true },
			filters = {
				custom = { "^.git$" }, -- Don't show git files in the tree
			},
			git = {
				show_on_open_dirs = false,
				ignore = false, -- Stop gitignored files and folders from being hidden
			},
		}
	end,
	init = function()
		local function open_on_startup()
			-- If nvim is starting with buffers open, do not open the tree
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.bo[buf].buflisted then
					return
				end
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
