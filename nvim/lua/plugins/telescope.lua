return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope", -- Needed for calling this from other plugins
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-symbols.nvim",
  },
  opts = function()
    local actions = require("telescope.actions")
    local h = require("helpers")
    local u = require("utilities")

    local function on_e(prompt)
      -- Close floats to avoid files being opened in small windows
      h.close_floats()
      actions.select_default(prompt)
    end

    return {
      pickers = {
        find_files = {
          -- Search hidden/dotfiles but not git files
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "-g",
            "!.git",
          },
        },
      },
      defaults = {
        initial_mode = "normal",
        layout_strategy = "vertical",
        layout_config = {
          height = 100,
          width = 100,
          scroll_speed = 9,
          mirror = true,
        },
        file_ignore_patterns = { "node_modules", "yarn.lock" },
        mappings = {
          i = { ["<CR>"] = u.on_enter },
          n = { ["<CR>"] = u.on_enter, ["e"] = on_e },
        },
      },
    }
  end,
  keys = function()
    local status, builtin = pcall(require, "telescope.builtin")
    if not status then return end

    local function with_preview(mode)
      return {
        initial_mode = mode,
        layout_config = {
          -- Only apply to pickers with previews - otherwise causes crash
          preview_height = 0.65,
          preview_cutoff = 30, -- If window too small, don't show preview
        },
      }
    end

    return {
      {
        "<leader>f",
        function() builtin.find_files(with_preview("insert")) end,
        desc = "Find file",
      },
      {
        "<leader>s",
        function() builtin.live_grep(with_preview("insert")) end,
        desc = "Find string",
      },
      {
        "<leader>t",
        ":TodoTelescope<CR>",
        desc = "Find todo",
      },
      { "<leader>l", ":TodoTelescope keywords=", desc = "Filter todo" },
      {
        "<leader>d",
        function()
          builtin.diagnostics({
            severity = { min = vim.diagnostic.severity.WARN },
          })
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>h",
        function() builtin.help_tags(with_preview("insert")) end,
        desc = "Get help",
      },
      {
        "<leader>r",
        function() builtin.resume({ initial_mode = "normal" }) end,
        desc = "Resume find",
      },
      {
        "<leader>i",
        function() builtin.symbols({ initial_mode = "insert" }) end,
        desc = "Insert symbol",
      },
      {
        "<localleader>k",
        function()
          require("utilities").ts_quickfix()
          builtin.quickfix(with_preview("normal"))
        end,
        desc = "TS issue list",
      },
    }
  end,
}
