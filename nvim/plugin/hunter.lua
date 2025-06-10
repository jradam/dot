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
      require("gitsigns").nav_hunk("next")
    end
  end
end

-- Inspect thing under cursor
local function inspect()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local preview = require("gitsigns").preview_hunk

  if #clients == 0 then
    preview()
    return
  end

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

vim.api.nvim_create_user_command("Hunt", hunt, {})
vim.api.nvim_create_user_command("Inspect", inspect, {})
