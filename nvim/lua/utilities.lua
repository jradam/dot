local M = {}

-- Run tsc and eslint and put all results in one quickfix list
function M.ts_quickfix()
	-- Clear quickfix list
	vim.fn.setqflist({})

	vim.api.nvim_command("echo 'Running tsc...'")
	vim.api.nvim_command("compiler tsc | setlocal makeprg=npx\\ tsc")
	vim.api.nvim_command("silent make")

	-- Get ts_errors back from quickfix
	local ts_errors = vim.fn.getqflist()

	vim.api.nvim_command("echo 'Running eslint...'")
	vim.api.nvim_command("compiler eslint | setlocal makeprg=yarn\\ lint\\ --format\\ compact")
	vim.api.nvim_command("silent make")

	-- Get eslint errors and append them to ts errors
	local eslint_errors = vim.fn.getqflist()
	for _, err in ipairs(eslint_errors) do
		table.insert(ts_errors, err)
	end

	-- Send the now combined list to quickfix
	vim.fn.setqflist(ts_errors)
end

-- Easypick custom diff preview
function M.diff_preview(opts)
	local previewers = require("telescope.previewers")
	local putils = require("telescope.previewers.utils")

	return previewers.new_buffer_previewer({
		title = "Diff preview",
		get_buffer_by_name = function(_, entry)
			return entry.value
		end,
		define_preview = function(self, entry, _)
			local file_name = entry.value
			local diff_command

			if not opts then
				diff_command = { "git", "--no-pager", "diff", "--", file_name }
			else
				diff_command = { "git", "--no-pager", "diff", opts.base_branch, "--", file_name }
			end

			putils.job_maker(diff_command, self.state.bufnr, {
				value = file_name,
				bufname = self.state.bufname,
				winid = self.state.winid,
			})
			putils.regex_highlighter(self.state.bufnr, "diff")
		end,
	})
end

-- TODO add a `yarn` in the `env/` dir to the bash install script
-- NOTE very useful https://github.com/3rd/linter
-- https://github.com/3rd/config/blob/master/home/dotfiles/nvim/lua/modules/language-support/lsp.lua
-- TODO tidy/simplify if possible eslint file

function M.eslint_setup(client)
	local sets = client.config.settings
	local util = require("lspconfig").util

	if sets.options == nil then
		sets.options = {}
	end

	local local_eslint = util.root_pattern(".eslintrc.js", ".eslintrc.json")(vim.fn.getcwd())
	if local_eslint then
		sets.useEslintrc = true
		sets.options.resolvePluginsRelativeTo = local_eslint
	else
		sets.useEslintrc = false
		sets.options.overrideConfigFile = vim.fn.stdpath("config") .. "/env/.eslintrc.json"
		sets.options.resolvePluginsRelativeTo = vim.fn.stdpath("config") .. "/env/node_modules"
		-- TODO do we need this?
		-- sets.nodePath = vim.fn.stdpath("config") .. "/env/node_modules"
	end
end

-- Nvim-tree helpers
local api = require("nvim-tree.api")
local toggle = 0

-- Nvim-tree multifunction for expanding folders and opening files
function M.multi(node)
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

-- Nvim-tree replace the open buffer with the one we are opening
function M.open_in_same()
	local node = api.tree.get_node_under_cursor()
	if node and node.type == "file" then
		api.tree.close()
		local current_buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_command("bdelete " .. current_buf)
		vim.api.nvim_command("edit " .. node.absolute_path)
	end
end

-- Nvim-tree do not close the tree if it is the last thing open
function M.close_unless_last()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buflisted then
			api.tree.close()
			break
		end
	end
end

-- Nvim-tree if we try to delete an open buffer, close it first to avoid an error
function M.safe_delete()
	local node = api.tree.get_node_under_cursor()

	if node and node.type == "file" then
		local open_buffers = vim.api.nvim_list_bufs()
		local node_path = node.absolute_path
		local buffer_to_close = nil
		local listed_buffer_count = 0

		for _, buf in ipairs(open_buffers) do
			if vim.bo[buf].buflisted then
				listed_buffer_count = listed_buffer_count + 1
			end
			if vim.api.nvim_buf_get_name(buf) == node_path then
				buffer_to_close = buf
			end
		end

		if listed_buffer_count == 1 and buffer_to_close then
			vim.notify("Cannot delete last open file", vim.log.levels.ERROR)
			return
		end

		if buffer_to_close then
			vim.api.nvim_buf_delete(buffer_to_close, { force = true })
		end

		local success, err = pcall(api.fs.remove, node)
		if not success then
			vim.notify("Error deleting file: " .. err, vim.log.levels.ERROR)
		end
	end
end

return M
