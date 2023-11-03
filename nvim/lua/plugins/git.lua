return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    -- TODO finish configuring this
    config = {
      list_opener = "copen",
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
  },
}
