-- Go to next interesting thing
local function hunt()
  if vim.fn.search("=======", "nw") > 0 then
    print("Conflict found")
    vim.cmd("GitConflictNextConflict")
  else
    local has_diagnostics = #vim.diagnostic.get(
      0,
      { severity = { min = vim.diagnostic.severity.WARN } }
    ) > 0
    if has_diagnostics then
      vim.diagnostic.jump({
        count = 1,
        severity = { min = vim.diagnostic.severity.WARN },
      })
    else
      require("gitsigns").nav_hunk("next", { navigation_message = false })
    end
  end
end

vim.api.nvim_create_user_command("Hunt", hunt, {})

-- Inspect thing under cursor
local function inspect()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1

  -- Check for diagnostics first
  local diagnostics = vim.diagnostic.get(0, { lnum = line })
  if #diagnostics > 0 then
    vim.diagnostic.open_float({ scope = "line", border = "rounded" })
    return
  end

  -- Check for LSP clients
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local preview = require("gitsigns").preview_hunk_inline

  if #clients == 0 then
    preview()
    return
  end

  -- Try LSP hover, fallback to git preview
  local params = vim.lsp.util.make_position_params(0, "utf-8")
  vim.lsp.buf_request(0, "textDocument/hover", params, function(_, result, _, _)
    if
        result
        and result.contents
        and result.contents.value
        and result.contents.value ~= ""
    then
      vim.lsp.buf.hover({ border = "rounded", max_width = 80 })
    else
      preview()
    end
  end)
end

vim.api.nvim_create_user_command("Inspect", inspect, {})

-- Open all changed git files
-- TODO: If not in git root, do nothing and send print 'not in root'
local function open_all_changed()
  local changed_files = vim.fn.systemlist("git diff --name-only HEAD")
  local untracked_files =
      vim.fn.systemlist("git ls-files --others --exclude-standard")

  local all_files = {}
  if vim.v.shell_error == 0 and #changed_files > 0 then
    for _, file in ipairs(changed_files) do
      table.insert(all_files, file)
    end
  end
  if vim.v.shell_error == 0 and #untracked_files > 0 then
    for _, file in ipairs(untracked_files) do
      table.insert(all_files, file)
    end
  end

  for _, file in ipairs(all_files) do
    vim.cmd("edit " .. vim.fn.fnameescape(file))
  end
end

vim.api.nvim_create_user_command("Shotgun", open_all_changed, {})

-- Clear Gitsign inline previews
local function clear_gitsigns()
  for name, id in pairs(vim.api.nvim_get_namespaces()) do
    if name:match("gitsigns") then
      vim.api.nvim_buf_clear_namespace(0, id, 0, -1)
    end
  end
end

vim.api.nvim_create_user_command("ClearGit", clear_gitsigns, {})
