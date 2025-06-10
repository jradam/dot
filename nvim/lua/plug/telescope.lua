return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Apparently makes it faster
  },
  opts = {
    extensions = { fzf = {} },
    defaults = {
      mappings = { n = { ["e"] = "select_default" } },
    },
    pickers = {
      find_files = {
        file_ignore_patterns = { "node_modules", ".git/" },
        hidden = true,
      },
      live_grep = {
        file_ignore_patterns = { "node_modules", ".git/" },
        additional_args = function() return { "--hidden" } end,
      },
    },
  },
  keys = function()
    local t = require("telescope.builtin")
    local function opts(mode)
      return {
        initial_mode = mode,
        layout_strategy = "vertical",
        layout_config = {
          height = 60,
          width = 100,
          scroll_speed = 9,
          mirror = true,
          preview_height = 0.65,
          preview_cutoff = 30, -- If window too small, don't show preview
        },
      }
    end
    return {
      {
        "<leader>f",
        function() t.find_files(opts("insert")) end,
        desc = "Find file",
      },
      {
        "<leader>s",
        function() t.live_grep(opts("insert")) end,
        desc = "Find string",
      },
      {
        "<leader>u",
        function() t.lsp_references(opts("normal")) end,
        desc = "Find uses",
      },
      {
        "<leader>b",
        function() t.resume({ initial_mode = "normal" }) end,
        desc = "Find resume",
      },
    }
  end,
}
