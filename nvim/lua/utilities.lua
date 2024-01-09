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

return M
