return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    require("which-key").setup({
      icons = { separator = "→", mappings = false, },
      sort = { "desc" },
    })
    local k = vim.keymap.set

    -- Actions
    k("n", "<leader>w", function() vim.cmd("w") end, { desc = "Write" })
    k("n", "<leader>m", ":Mason<cr>", { desc = "Mason" })
    k("n", "<leader>c", ":restart<cr>", { desc = "Restart" })
    k("n", "<leader>r", function() vim.cmd("checktime") end, { desc = "Refresh" })

    -- Text manipulation
    k("n", "K", "i<space><left>", { desc = "Insert space" })
    k("n", "<leader>a", "ggVG", { desc = "Select all" })
    k("v", "<C-c>", [["+y]], { desc = "System clip" })
    k("v", "<leader>r", function()
      return ':s/\\%V' .. vim.fn.escape(vim.fn.getreg('"'), '/\\') .. '//g<Left><Left>'
    end, { desc = "Replace", expr = true })

    -- Diagnostics
    k('n', '<leader>i', function() vim.lsp.buf.hover { border = 'rounded', max_width = 80 } end, { desc = 'Info' })
    k("n", "<leader>n", function()
      vim.diagnostic.jump({ count = 1 })
      vim.schedule(function()
        vim.diagnostic.open_float(nil, { focusable = false })
      end)
    end, { desc = "Next issue" })

    -- Close floating windows
    k("n", "<Esc>", function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= "" then
          vim.api.nvim_win_close(win, false)
        end
      end
    end, { desc = "Close windows" })
  end
}
