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
    k("n", "<leader>q", ":q<cr>", { desc = "Quit" })
    k("n", "<leader>r", function()
      vim.cmd("checktime")
      vim.cmd("nohlsearch")
      vim.cmd("e")
    end, { desc = "Refresh buffer" })
    k("n", "<leader>R", ":restart<cr>", { desc = "Restart nvim" })
    k("n", "<leader>m", ":messages<cr>", { desc = "Messages" })

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

    -- Diagnostics
    k(
      "n",
      "<leader>i",
      function() vim.lsp.buf.hover({ border = "rounded", max_width = 80 }) end,
      { desc = "Tag info" }
    )

    k("n", "<leader>n", function()
      if vim.fn.search("=======", "nw") > 0 then
        vim.cmd("GitConflictNextConflict")
      else
        vim.diagnostic.jump({ count = 1 })
        vim.schedule(function() vim.diagnostic.open_float() end)
      end
    end, { desc = "LSP next" })

    k("n", "<leader>j", "<C-]>", { desc = "Tag jump" })

    -- Close floating windows
    k("n", "<Esc>", function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= "" then
          vim.api.nvim_win_close(win, false)
        end
      end
    end, { desc = "Close windows" })
  end,
}
