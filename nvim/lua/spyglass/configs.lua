local M = {}
local h = require("spyglass.helpers")

function M.gitsigns()
  local state = require("gitsigns.config").config

  h.spyglass("Gitsigns", {
    {
      label = state.numhl and "Turn gitsigns off" or "Turn gitsigns on",
      cmd = "Gitsigns toggle_numhl",
    },
    {
      label = state.show_deleted and "Turn deleted off" or "Turn deleted on",
      cmd = "Gitsigns toggle_deleted",
    },
    {
      label = state.current_line_blame and "Turn blame off" or "Turn blame on",
      cmd = "Gitsigns toggle_current_line_blame",
    },
    {
      label = state.base == "main" and "Switch to head" or "Switch to main",
      cmd = "Gitsigns "
        .. (
          state.base == "main" and "change_base HEAD true"
          or "change_base main true"
        ),
    },
  })
end

return M
