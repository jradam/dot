local ns = vim.api.nvim_create_namespace("indentured")

local function get_indent_level(line)
  local leading_whitespace = line:match("^%s*")
  return #leading_whitespace
end

local function highlight_current_indent()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1

  -- Clear existing highlights
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  -- Get current line text and indentation
  local line_text = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
  local current_indent = get_indent_level(line_text)

  -- Skip if no indentation
  if current_indent == 0 then return end

  local line_count = vim.api.nvim_buf_line_count(bufnr)

  -- Highlight all lines with the same indentation level
  for line = 0, line_count - 1 do
    local line_content = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1] or ""
    local line_indent = get_indent_level(line_content)

    -- Handle empty lines or lines with at least the current indent level
    if line_content:match("^%s*$") or line_indent >= current_indent then
      local col_pos = math.max(0, current_indent - 2)

      if line_content:match("^%s*$") then
        -- Empty line - add guide at column 0
        vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
          virt_text = { { string.rep(" ", col_pos) .. "│", "Indent" } },
          virt_text_pos = "overlay",
          priority = 100,
        })
      elseif #line_content > current_indent then
        -- Non-empty line
        if current_indent > 0 and current_indent <= #line_content and col_pos < #line_content then
          local char_at_pos = line_content:sub(current_indent, current_indent)
          if char_at_pos == " " or char_at_pos == "\t" then
            vim.api.nvim_buf_set_extmark(bufnr, ns, line, col_pos, {
              virt_text = { { "│", "Indent" } },
              virt_text_pos = "overlay",
              priority = 100,
            })
          end
        end
      end
    end
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

