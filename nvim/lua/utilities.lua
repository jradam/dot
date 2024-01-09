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

-- Custom diff preview for Easypick
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

return M
