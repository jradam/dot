return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    jump = { autojump = true }, -- If only one match, jump to it
    label = { uppercase = false }, -- Do not allow uppercase jump labels
    modes = { char = { enabled = false } }, -- Disable when in other modes
  },
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  },
}
