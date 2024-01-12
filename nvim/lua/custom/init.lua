-- Buf Captain: a minimalist's alternative to bufferline
-- A NeoVim plugin to manage your buffers

-- TODO turn this into a proper plugin
-- TODO make it so that when selecting a buffer past "...", it moves along and adds a "..." to the start
-- TODO add diagnostic colors
-- TODO make ESC also trigger buf_cpt?
-- TODO add in path bit before / if this buffer has same name as another buffer
-- TODO add indicator or color to indicate changes in buffer

-- TODO sorting
-- make new buffers always open at end of list (or, optionally at start of list)
-- add shortcuts for moving selected buffer left or right in list
-- add option to keep buffers sorted alphabetically
-- add option to keep buffers sorted by time open

-- User options
local MAX_NAME_LENGTH = 15
local SHOW_EXTENSIONS = false
local CURRENT_HIGHLIGHT = "#FFFFA5"
local OTHER_HIGHLIGHT = "#FFB86C"
local COMPENSATION = 12 -- Run the included test function to find out what this should be
local MAX_STRING = " ... "
local LEFT_BRACKET = "["
local RIGHT_BRACKET = "]"

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

-- Main function
local function buf_cpt()
	local cmd_max = vim.o.columns - COMPENSATION
	local buf_table = {}
	local total_length = 0
	local reached_max = false

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buflisted then
			local name_modifier = SHOW_EXTENSIONS and ":t" or ":t:r"
			local buf_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), name_modifier)

			-- Use a dash for unnamed buffers
			buf_name = buf_name == "" and "-" or buf_name

			-- Limit name length to MAX_NAME_LENGTH
			if buf_name and #buf_name > MAX_NAME_LENGTH then
				buf_name = string.sub(buf_name, 1, MAX_NAME_LENGTH - 1)
				buf_name = buf_name .. "…"
			end

			-- Find out if this is the current buf, add characters if so
			local is_current = buf == vim.api.nvim_get_current_buf()
			if is_current then
				buf_name = LEFT_BRACKET .. buf_name .. RIGHT_BRACKET
			else
				buf_name = string.rep(" ", #LEFT_BRACKET) .. buf_name .. string.rep(" ", #RIGHT_BRACKET)
			end

			-- Keep track of our length
			local new_length = total_length + #buf_name

			if new_length < (cmd_max - #MAX_STRING) then
				table.insert(buf_table, { buf_name, is_current and "BufCptCurrent" or "BufCptOther" })
				total_length = new_length
			else
				if not reached_max then
					table.insert(buf_table, { MAX_STRING, "BufCptOther" })
					reached_max = true
				end
			end
		end
	end

	vim.api.nvim_echo(buf_table, false, {})
end

-- Listen for cursor moves and update
vim.api.nvim_create_autocmd({ "CursorMoved" }, { pattern = "*", callback = buf_cpt })

-- Controls
local function next()
	vim.cmd(":bn")
	buf_cpt()
end
k("n", NEXT_BUFFER, next, { desc = "Next buffer", silent = true })

local function previous()
	vim.cmd(":bp")
	buf_cpt()
end
k("n", PREV_BUFFER, previous, { desc = "Prev buffer", silent = true })

local function close()
	vim.cmd(":bd")
	buf_cpt()
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
	buf_cpt()
end, { desc = "Close others", silent = true })

-- Testing
-- This test finds the max message length Buf Captain can send to this particular user's command line before triggering the "Press ENTER to continue" prompt.
-- Starting at full width minus some big number (vim.o.columns - NUMBER), we decrease the size of NUMBER until the prompt triggers.
-- The final value plus one (since we want the one just before the prompt was triggered) becomes the recommended COMPENSATION setting for the user.
local function test_compensation()
	local function test_echo(number)
		local description = "DO NOT press ENTER. You should set COMPENSATION to: "
			.. (number + 1)
			.. ". Press ESC to close."
		local characters = string.rep(" ", vim.o.columns - number - #description)
		vim.api.nvim_echo({ { (description .. characters) } }, false, {})
	end

	local function process_test(number)
		if number < 0 then
			return
		end

		test_echo(number)
		process_test(number - 1)
	end

	process_test(500)
end

k("n", RUN_COMPENSATION_TEST, test_compensation, { desc = "Test", silent = true })
