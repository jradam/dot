local M = {}

-- Close all unmodified floating windows
function M.close_floats()
	for _, win in pairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local is_modified = vim.api.nvim_buf_get_option(buf, "modified")
		local is_floating = vim.api.nvim_win_get_config(win).relative ~= ""

		if is_floating and not is_modified then
			vim.api.nvim_win_close(win, false)
		end
	end
end

-- Close all non-terminal buffers except the current one
function M.close_all_else()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= vim.api.nvim_get_current_buf() and vim.api.nvim_buf_is_loaded(buf) then
			local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
			if buftype ~= "terminal" then
				vim.api.nvim_buf_delete(buf, { force = false })
			end
		end
	end
end

return M
