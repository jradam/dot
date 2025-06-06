return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Apparently makes it faster
  },
  opts = { extensions = { fzf = {} } },
  keys = function()
    local t = require("telescope.builtin")
    local opts = {

      initial_mode = "insert",
      layout_strategy = "vertical",
      layout_config = {
        height = 60,
        width = 100,
        scroll_speed = 9,
        mirror = true,
        preview_height = 0.65,
        preview_cutoff = 30, -- If window too small, don't show preview
      },
      mappings = { n = { ["e"] = "select_default" } },
    }
    return {
      {
        "<leader>f",
        function() t.find_files(opts) end,
        desc = "Find file",
      },
      {
        "<leader>s",
        function() t.live_grep(opts) end,
        desc = "Find string",
      },
      {
        "<leader>b",
        function() t.resume({ initial_mode = "normal" }) end,
        desc = "Resume find",
      },
    }
  end,
}
