return {
  dir = "~/bufcmd",
  -- "jradam/bufcmd",
  event = { "BufReadPre" }, -- Load when opening any buffer
  opts = {
    theme = {
      active = { fg = "#FFFFA5", bg = "" },
      inactive = { fg = "#FFB86C", bg = "" },
      modified = { fg = "#8BE9FD", bg = "" },
    },
  },
  keys = {
    { "<tab>", ":bn<cr>", desc = "Next buffer", silent = true },
    { "<s-tab>", ":bp<cr>", desc = "Previous buffer", silent = true },
    { "<leader>x", ":bw<cr>", desc = "Close buffer", silent = true },
    { "<leader>o", ":BufCmdCloseOthers<cr>", desc = "Close others", silent = true },
  },
}
