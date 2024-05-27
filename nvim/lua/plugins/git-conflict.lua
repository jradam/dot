return {
  "akinsho/git-conflict.nvim",
  -- TODO: change back to `version` from `branch` after next release
  -- version = "*",
  branch = "main",
  opts = function()
    local k = vim.keymap.set

    -- TODO: Add this to a better shortcut?

    k("n", "<localleader>cc", function()
      local actions = {
        GitConflictCurrent = "ours",
        GitConflictCurrentLabel = "ours",
        GitConflictAncestor = "base",
        GitConflictAncestorLabel = "base",
        GitConflictIncoming = "theirs",
        GitConflictIncomingLabel = "theirs",
      }
      local line = vim.api.nvim_get_current_line()
      local choose = require("git-conflict").choose

      if line:match("=======") then
        choose("both")
        return
      end

      local mark = vim.iter(vim.inspect_pos().extmarks):find(
        function(e) return e.ns == "git-conflict" and actions[e.opts.hl_group] end
      )

      if not mark then
        vim.notify("No conflict under cursor", vim.log.levels.WARN)
        return
      end

      choose(actions[mark.opts.hl_group])
    end)

    k(
      "n",
      "<localleader>cn",
      ":GitConflictNextConflict<CR>",
      { desc = "Next conflict" }
    )
    k(
      "n",
      "<localleader>cN",
      ":GitConflictPrevConflict<CR>",
      { desc = "Prev conflict" }
    )
    k(
      "n",
      "<localleader>c0",
      ":GitConflictChooseNone<CR>",
      { desc = "Choose none" }
    )
    k(
      "n",
      "<localleader>co",
      ":GitConflictChooseOurs<CR>",
      { desc = "Choose ours" }
    )
    k(
      "n",
      "<localleader>ct",
      ":GitConflictChooseTheirs<CR>",
      { desc = "Choose theirs" }
    )

    return {
      disable_diagnostics = true,
      list_opener = function() require("telescope.builtin").quickfix({}) end,
      highlights = {
        current = "DiffCurrent",
        incoming = "DiffIncoming",
      },
    }
  end,
}
