return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    require("which-key").setup({
      icons = { separator = "→", mappings = false },
      sort = { "desc" },
    })
    local k = vim.keymap.set

    -- Actions
    k("n", "<leader>w", ":w<cr>", { desc = "Write" })
    k(
      "n",
      "<leader>W",
      function() vim.cmd("noautocmd w") end,
      { desc = "Write no format" }
    )
    k("n", "<leader>q", ":q<cr>", { desc = "Quit" })
    k("n", "<leader>r", function()
      vim.cmd("checktime")
      vim.cmd("nohlsearch")
      vim.cmd("e")
    end, { desc = "Refresh buffer" })
    k("n", "<leader>R", ":restart<cr>", { desc = "Restart nvim" })
    k("n", "<leader>m", ":messages<cr>", { desc = "Messages" })
    k("n", "<leader>M", ":messages clear<CR>", { desc = "Clear messages" })
    k("n", "x", '"_x', { desc = "Delete without register" })

    -- Movement
    k("n", "j", "gj", { desc = "Visual move up" })
    k("n", "k", "gk", { desc = "Visual move down" })

    -- Text manipulation
    k("n", "K", "i<space><left>", { desc = "Insert space" })
    k("n", "<leader>a", "ggVG", { desc = "Select all" })
    k("v", "<C-c>", [["+y]], { desc = "System clip" })
    k("v", "s", ":sort<cr>", { desc = "Sort" })
    k(
      "v",
      "r",
      function()
        return ":s/\\%V"
          .. vim.fn.escape(vim.fn.getreg('"'), "/\\")
          .. "//g<Left><Left>"
      end,
      { desc = "Replace", expr = true }
    )
    k("x", "p", [["_dP]], { desc = "Copyless paste" })

    -- Diagnostics
    k("n", "<leader>n", "<cmd>Hunt<cr>", { desc = "Hunt" })
    k("n", "<leader>i", "<cmd>Inspect<cr>", { desc = "Inspect" })
    k("n", "<leader>d", "<cmd>SpyLspActions<cr>", { desc = "LSP Actions" })
    k("n", "<leader>C", "<cmd>SpyConflicts<cr>", { desc = "Conflict search" })

    k("n", "<leader>j", "<C-]>", { desc = "Tag jump" })

    -- Close floating windows
    k({ "n", "t" }, "<Esc>", function()
      vim.cmd("ClearGit") -- Clear Gitsign inline previews

      -- Close floating windows
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= "" then
          vim.api.nvim_win_close(win, false)
        end
      end
    end, { desc = "Close windows" })
  end,
}
