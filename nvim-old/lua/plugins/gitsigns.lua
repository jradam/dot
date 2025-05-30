-- NOTE: Keys for this in Spyglass

return {
  "lewis6991/gitsigns.nvim",
  opts = function()
    vim.keymap.set("n", "<leader>G", function()
      local state = require("gitsigns.config").config

      require("spyglass").spy("Gitsigns", {
        {
          label = state.numhl and "Turn gitsigns off" or "Turn gitsigns on",
          cmd = "Gitsigns toggle_numhl",
        },
        {
          label = state.show_deleted and "Turn deleted off"
            or "Turn deleted on",
          cmd = "Gitsigns toggle_deleted",
        },
        {
          label = state.current_line_blame and "Turn blame off"
            or "Turn blame on",
          cmd = "Gitsigns toggle_current_line_blame",
        },
        {
          label = state.base == "main" and "Switch to head" or "Switch to main",
          cmd = (
            "Gitsigns "
            .. (
              state.base == "main" and "change_base HEAD true"
              or "change_base main true"
            )
          ),
        },
      })
    end, { desc = "Gitsigns" })

    return {
      current_line_blame_opts = {
        virt_text_pos = "right_align",
        delay = 0,
      },
      signcolumn = false,
    }
  end,
}
