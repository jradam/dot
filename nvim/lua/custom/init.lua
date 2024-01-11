-- Buff Captain
-- A NeoVim plugin to manage your buffers

-- User options
local MAX_NAME_LENGTH = 10
local SHOW_EXTENSIONS = false
local CURRENT_HIGHLIGHT = "#FFFFA5"
local OTHER_HIGHLIGHT = "#FFB86C"
local COMPENSATION = 12 -- Reduce until no "..." in message when running test funtion

-- User keymaps
local NEXT_BUFFER = "<Tab>"
local PREV_BUFFER = "<S-Tab>"
local CLOSE_BUFFER = "<leader>x"
local CLOSE_OTHERS = "<leader>z"
local RUN_COMPENSATION_TEST = "<leader>i"

-- Setup
local k = vim.keymap.set
vim.cmd([[ highlight BufCptCurrent guifg=]] .. CURRENT_HIGHLIGHT .. [[ ]])
vim.cmd([[ highlight BufCptOther guifg=]] .. OTHER_HIGHLIGHT .. [[ ]])
vim.cmd([[ highlight BufCptTestHighlight guifg=#F1FA8C guibg=#282A36 ]])

-- Main function
local function buf_cmd()
	local buf_list = vim.api.nvim_list_bufs()
	local buf_table = {}
	local buf_current = vim.api.nvim_get_current_buf()
	local total_length = 0
	local at_max_buf = false
	local cmd_max = vim.o.columns - COMPENSATION

	for _, buf in ipairs(buf_list) do
		if vim.bo[buf].buflisted then
			local name_modifier = SHOW_EXTENSIONS and ":t" or ":t:r"
			local this_buf = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), name_modifier)

			-- Limit name length to MAX_NAME_LENGTH
			if this_buf and #this_buf > MAX_NAME_LENGTH then
				this_buf = string.sub(this_buf, 1, MAX_NAME_LENGTH - 1)
				this_buf = this_buf .. "…"
			end

			if this_buf then
				local this_buffer = buf == buf_current and "[" .. this_buf .. "]" or " " .. this_buf .. " "
				local display_length = #this_buffer

				local new_length = total_length + display_length

				if new_length < (cmd_max - 9) and not at_max_buf then
					table.insert(buf_table, { this_buffer, buf == buf_current and "BufCptCurrent" or "BufCptOther" })
					total_length = new_length
				else
					if at_max_buf == false then
						table.insert(buf_table, { " ... ", "BufCmdOther" })
					end
				end
			end
		end
	end

	vim.api.nvim_echo(buf_table, false, {})
end

vim.api.nvim_create_autocmd({ "CursorMoved" }, { pattern = "*", callback = buf_cmd })

-- Controls

local function next()
	vim.cmd(":bn")
	buf_cmd()
end
k("n", NEXT_BUFFER, next, { desc = "Next buffer", silent = true })

local function previous()
	vim.cmd(":bp")
	buf_cmd()
end
k("n", PREV_BUFFER, previous, { desc = "Prev buffer", silent = true })

local function close()
	vim.cmd(":bd")
	buf_cmd()
end
k("n", CLOSE_BUFFER, close, { desc = "Close buffer", silent = true })

k("n", CLOSE_OTHERS, function()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= vim.api.nvim_get_current_buf() and vim.api.nvim_buf_is_loaded(buf) then
			local buftype = vim.bo[buf].buftype
			if buftype ~= "terminal" then
				vim.api.nvim_buf_delete(buf, { force = false })
			end
		end
	end
	buf_cmd()
end, { desc = "Close others", silent = true })

local function test_compensation()
	local function spin_echo(string)
		vim.api.nvim_echo({ { " " .. string .. " ", "BufCptTestHighlight" } }, false, {})
	end

	local function test_echo(number)
		local description = "[ Compensation: " .. number .. " ] -> "
		local characters = string.rep("X", vim.o.columns - number - #description)
		spin_echo(description .. characters)
	end

	local user_info = {
		"This test will only take a few seconds",
		-- "We will print a few lines of characters",
		-- 'As soon as "..." disappears from the characters',
		-- "Make a note of your compensation number",
	}

	local test_numbers = {}
	for i = 10, 15 do
		table.insert(test_numbers, i)
	end

	local function spin(string, callback)
		local spinner = { "[  ]", "[- ]", "[--]" }
		local spinner_index = 1
		local spinner_timer = vim.loop.new_timer()
		local speed_ms = 1000
		local expiry_ms = vim.loop.now() + 3000

		spinner_timer:start(
			0,
			speed_ms,
			vim.schedule_wrap(function()
				if vim.loop.now() >= expiry_ms then
					spinner_timer:stop()
					spinner_timer:close()
					if callback then
						callback()
					end
					return
				end
				spin_echo(spinner[spinner_index] .. " " .. string)
				vim.cmd("redraw")
				spinner_index = (spinner_index % #spinner) + 1
			end)
		)
	end

	local function test(number, callback)
		local testing_timer = vim.loop.new_timer()
		local delay_ms = 1500

		testing_timer:start(
			delay_ms,
			0,
			vim.schedule_wrap(function()
				test_echo(number)
				testing_timer:stop()
				testing_timer:close()
				if callback then
					callback()
				end
			end)
		)
	end

	local function process_spin(messages, process_callback, index)
		index = index or 1
		if index > #messages then
			if process_callback then
				process_callback()
				return
			else
				return
			end
		end

		spin(messages[index], function()
			process_spin(messages, process_callback, index + 1)
		end)
	end

	local function process_test(messages, index)
		index = index or 1
		if index > #messages then
			print("Test complete")
			return
		end

		test(messages[index], function()
			process_test(messages, index + 1)
		end)
	end

	process_spin(user_info, function()
		process_test(test_numbers)
	end)
end

k("n", RUN_COMPENSATION_TEST, test_compensation, { desc = "Test", silent = true })
