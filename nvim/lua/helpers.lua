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

-- Print a table
function M.print_table(table) print(vim.inspect(table)) end

-- Determine if a string looks like a file path
function M.is_file_path(string)
  -- Either contain '/' or end with a typical file extension
  return string:match("^.+/.+$") or string:match("%.%a+$") ~= nil
end

-- Check if a buffer exists
function M.buf_exists(buf_id)
  return vim.api.nvim_buf_is_valid(buf_id)
    and vim.api.nvim_buf_is_loaded(buf_id)
end

-- Converts a long filepath (e.g. /folder1/folder2/folder3/file.ext) to "folder3/file.ext"
function M.simplify_path(filepath)
  local parent = vim.fn.fnamemodify(filepath, ":h:t")
  local filename = vim.fn.fnamemodify(filepath, ":t")
  return parent .. "/" .. filename
end

-- Check if a file is already open
function M.is_file_open(filepath)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if M.buf_exists(buf) then
      local buf_path = vim.api.nvim_buf_get_name(buf)
      if M.simplify_path(buf_path) == M.simplify_path(filepath) then
        return true
      end
    end
  end
  return false
end

-- Split a string by a separator
function M.split(string, separator)
  local result = {}
  for token in string.gmatch(string, "[^" .. separator .. "]+") do
    table.insert(result, token)
  end
  return result
end

return M
