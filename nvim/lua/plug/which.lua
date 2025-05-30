-- TODO: Pull request adding option to disable the 'close / back' text at bottom
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    icons = { separator = "→", mappings = false,  },
    sort = { "desc" },
  },
}

