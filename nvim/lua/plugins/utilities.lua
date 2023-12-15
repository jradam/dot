return {
  -- NOTE auto save
  -- {
  --   "pocco81/auto-save.nvim",
  --   branch = "dev",
  --   opts = { execution_message = { message = "" } },
  -- },
  {
    "echasnovski/mini.move",
    config = function()
      require("mini.move").setup({
        mappings = {
          left = "H",
          right = "L",
          down = "J",
          up = "K",
        },
      })
    end,
  },
  {
    -- TODO turn off non-comment keywords in TodoTelescope
    "folke/todo-comments.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    opts = {
      signs = false,
      keywords = {
        NEED = {
          icon = "",
          color = "hint",
        },
      },
      highlight = {
        multiline = false,
        keyword = "bg",
        pattern = [[.*<(KEYWORDS)\s*]],
      },
      search = {
        pattern = [[\b(KEYWORDS)\b]],
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--hidden",
          "--glob=!.git",
        },
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      local ts = require("ts_context_commentstring.integrations.comment_nvim")
      require("Comment").setup({ pre_hook = ts.create_pre_hook() })
    end,
  },
  -- TODO interferes with copilot. Do I even like autopairs?
  -- {
  --   "windwp/nvim-autopairs",
  --   config = true,
  -- },
  -- TODO currently broken https://github.com/windwp/nvim-ts-autotag/issues/125
  -- {
  --   "windwp/nvim-ts-autotag",
  --   config = true,
  -- },
  {
    "numToStr/BufOnly.nvim",
    keys = {
      -- TODO silent not work, fork this and fix
      { "<leader>z", vim.cmd.BufOnly, desc = "close all other", silent = true },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame_opts = {
          virt_text_pos = "right_align",
          delay = 0,
        },
        signcolumn = false,
      })

      local k = vim.keymap.set
      k("n", "<leader>gg", function()
        vim.cmd([[Gitsigns toggle_numhl]])
        vim.cmd([[sleep 100m]])
        vim.cmd([[Gitsigns change_base main]])
        vim.cmd([[sleep 100m]])
        vim.cmd([[Gitsigns toggle_deleted]])
        -- vim.cmd([[sleep 100m]])
        -- vim.cmd([[Gitsigns toggle_word_diff]])
      end, {
        desc = "Toggle gitsigns",
        silent = true,
      })
      k("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle blame" })
      k("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", { desc = "Git diff" })
      k("n", "<leader>gc", ":Gitsigns change_base ", { desc = "Change base" })
    end,
  },
  {
    "chrisgrieser/nvim-spider",
    config = function()
      local k = vim.keymap.set

      k({ "n", "o", "x" }, "w", function()
        require("spider").motion("w")
      end, { desc = "Spider-w" })

      k({ "n", "o", "x" }, "e", function()
        require("spider").motion("e")
      end, { desc = "Spider-e" })

      k({ "n", "o", "x" }, "b", function()
        require("spider").motion("b")
      end, { desc = "Spider-b" })

      k({ "n", "o", "x" }, "ge", function()
        require("spider").motion("ge")
      end, { desc = "Spider-ge" })
    end,
  },
  -- TODO very annoying in styled-components
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   config = function()
  --     require("lsp_signature").setup({
  --       floating_window = false,
  --       hint_prefix = "",
  --       hint_scheme = "VirtualText",
  --     })
  --   end,
  -- },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}
