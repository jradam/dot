-- undohelper.lua - Prevents cursor jumping to imports during undo/redo operations

local M = {}

-- Check if cursor is on an import-related line using multiple methods
function M.is_on_import()
  -- First try treesitter for accurate detection
  local has_ts, ts = pcall(require, "nvim-treesitter.ts_utils")
  if has_ts then
    local node = ts.get_node_at_cursor()
    if node then
      -- Check current node and walk up parents
      while node do
        local type = node:type()
        if
          type == "import_statement"
          or type == "import_declaration"
          or type == "named_imports"
          or type == "import_clause"
          or type == "import_specifier"
        then
          return true
        end
        node = node:parent()
      end
    end
  end

  -- Fallback to enhanced regex for various import patterns
  -- Get more context by checking several lines
  local bufnr = vim.api.nvim_get_current_buf()
  local line_nr = vim.fn.line(".")
  local line_count = vim.api.nvim_buf_line_count(bufnr)

  -- Check current line and a few above/below
  for i = math.max(1, line_nr - 3), math.min(line_count, line_nr + 3) do
    local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]

    -- Common import patterns in various languages
    if
      line:match("import%s")
      or line:match("import%s*{")
      or line:match("import%s*%*")
      or line:match("from%s+['\"]")
      or line:match("require%s*%(")
      or line:match("['\"]%s*from%s+['\"]")
      -- Additional ES6/TypeScript import patterns
      or line:match("^%s*import")
      or line:match("^%s*export%s+{")
      or line:match("^%s*}%s+from")
      or line:match("^%s*from%s+['\"]")
    then
      return true
    end
  end

  return false
end

-- Set up undo/redo keymaps with import protection
function M.setup()
  -- Handle undo
  vim.keymap.set("n", "u", function()
    local curpos = vim.fn.getcurpos()
    vim.cmd("normal! u")

    if M.is_on_import() then vim.fn.setpos(".", curpos) end
  end, { noremap = true })

  -- Handle redo
  vim.keymap.set("n", "<C-r>", function()
    local curpos = vim.fn.getcurpos()
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<C-r>", true, false, true),
      "n",
      false
    )
    vim.defer_fn(function()
      if M.is_on_import() then vim.fn.setpos(".", curpos) end
    end, 0)
  end, { noremap = true })
end

return M

