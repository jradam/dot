local M = {}

M.modes = {
  "n", -- Normal
  "v", -- Visual and Select
  "s", -- Select
  "x", -- Visual
  "o", -- Operator-pending
  "!", -- Insert and Command-line
  "i", -- Insert
  "l", -- ":lmap" mappings for Insert, Command-line and Lang-Arg
  "c", -- Command-line
  "t", -- Terminal-Job
}

function M.setup_lsp()
  local lsp_configs = {}

  for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
    local server_name = vim.fn.fnamemodify(f, ':t:r')
    table.insert(lsp_configs, server_name)
  end

  vim.lsp.enable(lsp_configs)
end



return M
