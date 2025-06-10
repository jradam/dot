return {
  "akinsho/git-conflict.nvim",
  version = "*",
  opts = function()
    local k = vim.keymap.set

    k("n", "<leader>c", function()
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
    end, { desc = "Conflict choose" })

    return {
      diagnostics = { enable = false },
      list_opener = function() require("telescope.builtin").quickfix({}) end,
      highlights = {
        current = "DiffCurrent",
        incoming = "DiffIncoming",
      },
    }
  end,
}
