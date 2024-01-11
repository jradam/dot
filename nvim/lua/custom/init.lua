local k = vim.keymap.set

vim.cmd([[
 highlight BufCmdSelected guifg=#FFFFA5 
 highlight BufCmdOther guifg=#FFB86C
]])

local function buf_cmd()
	local buffers = vim.api.nvim_list_bufs()
	local buffer_table = {}
	local current = vim.api.nvim_get_current_buf()
	local cmd_line_width = vim.o.columns
	local total_length = 0
	-- TODO need something listening for the list getting shorter and then changing this back to false and removing " ... " from table too
	local max_buffers = false

	for _, buf in ipairs(buffers) do
		if vim.bo[buf].buflisted then
			local buf_name = vim.api.nvim_buf_get_name(buf)
			local filename = vim.fn.fnamemodify(buf_name, ":t")

			if filename then
				local this_buffer = buf == current and "[" .. filename .. "]" or " " .. filename .. " "
				local display_length = #this_buffer

				local new_length = total_length + display_length
				print(new_length)
				print(cmd_line_width)

				-- TODO why 9 works?
				if new_length < (cmd_line_width - 9) and max_buffers == false then
					table.insert(buffer_table, { this_buffer, buf == current and "BufCmdSelected" or "BufCmdOther" })
					total_length = new_length
				else
					if max_buffers == false then
						table.insert(buffer_table, { " ... ", "BufCmdOther" })
					end
				end
			end
		end
	end

	vim.api.nvim_echo(buffer_table, false, {})
end

vim.api.nvim_create_autocmd({ "CursorMoved" }, { pattern = "*", callback = buf_cmd })

local function next()
	vim.cmd(":bn")
	buf_cmd()
end
k("n", "<Tab>", next, { desc = "Next buffer", silent = true })

local function previous()
	vim.cmd(":bp")
	buf_cmd()
end
k("n", "<S-Tab>", previous, { desc = "Prev buffer", silent = true })

local function close()
	vim.cmd(":bd")
	buf_cmd()
end
k("n", "<leader>x", close, { desc = "Close buffer", silent = true })

k("n", "<leader>z", function()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= vim.api.nvim_get_current_buf() and vim.api.nvim_buf_is_loaded(buf) then
			local buftype = vim.bo[buf].buftype
			if buftype ~= "terminal" then
				vim.api.nvim_buf_delete(buf, { force = false })
			end
		end
	end

	buf_cmd()
end, { desc = "Close all else", silent = true })
