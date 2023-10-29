return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    jump = {
      autojump = true,
    },
    highlight = {
      label = {
        uppercase = false,
        current = true,
      },
      backdrop = true,
    },
    modes = {
      char = { enabled = false },
    },
  },
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
    },
  },
}
