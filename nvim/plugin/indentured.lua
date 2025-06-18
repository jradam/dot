local ns = vim.api.nvim_create_namespace("indentured")
local only_whitespace = "^%s*$"
local has_content = "%S"

local function get_line_contents(bufnr, row)
  return vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
end

-- Get leading whitespace count for line
local function get_indent_level(bufnr, row)
  return #get_line_contents(bufnr, row):match("^%s*")
end

local function add_guide(bufnr, line_num, col, text)
  vim.api.nvim_buf_set_extmark(bufnr, ns, line_num, col, {
    virt_text = { { text, "Indent" } },
    virt_text_pos = "overlay",
    priority = 100,
  })
end

local function highlight_current_indent()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Clear old guide lines
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1
  local col = cursor[2]

  -- Skip if cursor in first column
  if col == 0 then return end

  -- Get current indentation
  local current_indent = get_indent_level(bufnr, row)

  -- Skip if no indentation
  if current_indent == 0 then return end

  local line_count = vim.api.nvim_buf_line_count(bufnr)

  -- Find the boundaries of the current block
  local block_start = 0
  local block_end = line_count - 1

  -- Find block start -> look backwards for a line with less indentation
  for i = row - 1, 0, -1 do
    local line_content = get_line_contents(bufnr, i)
    if line_content:match(has_content) and get_indent_level(bufnr, i) < current_indent then
      block_start = i
      break
    end
  end

  -- Find block end -> look forwards from the block_start for a line with less or equal indentation
  local start_indent = get_indent_level(bufnr, block_start)
  for i = row + 1, line_count - 1 do
    local line_content = get_line_contents(bufnr, i)
    if line_content:match(has_content) and get_indent_level(bufnr, i) <= start_indent then
      block_end = i - 1
      break
    end
  end

  -- For each line in our current block:
  for line = block_start, block_end do
    local line_content = get_line_contents(bufnr, line)
    local col_pos = math.max(0, current_indent - 2)

    -- Add guide at the correct level on empty lines
    if line_content:match(only_whitespace) then
      add_guide(bufnr, line, 0, string.rep(" ", col_pos) .. "│")
      goto continue
    end

    local target_character = line_content:sub(current_indent, current_indent)
    local target_guide = line_content:sub(col_pos + 1, col_pos + 1)

    -- Only add guide if target line has whitespace and target guide position is empty
    local line_is_indented = target_character == " " or target_character == "\t"
    local guide_space_free = target_guide == " " or target_guide == "\t" or target_guide == ""

    if line_is_indented and guide_space_free then
      add_guide(bufnr, line, col_pos, "│")
    end

    ::continue::
  end
end

local group = vim.api.nvim_create_augroup("Indentured", { clear = true })

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufEnter" }, {
  group = group,
  callback = highlight_current_indent,
})

vim.api.nvim_create_autocmd("BufLeave", {
  group = group,
  callback = function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  end,
})
