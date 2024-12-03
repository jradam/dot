return {
  dir = "~/bufcmd_new",
  -- "jradam/bufcmd",
  event = { "BufReadPre" }, -- Load when opening any buffer
  opts = {
    -- compensation = 12,
    -- theme = {
    --   current = { fg = "#FFFFA5", bg = "" },
    --   inactive = { fg = "#FFB86C", bg = "" },
    --   modified = { fg = "#8BE9FD", bg = "" },
    --   current_modified = { fg = "#A4FFFF", bg = "" },
    -- },
  },
  keys = {
    { "<tab>", ":bn<cr>", desc = "Next buffer", silent = true },
    { "<s-tab>", ":bp<cr>", desc = "Previous buffer", silent = true },
    { "<leader>x", ":bw<cr>", desc = "Close buffer", silent = true },
  },
}
