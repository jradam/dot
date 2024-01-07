return {
  "Mofiqul/dracula.nvim",
  opts = function()
    local c = require("dracula").colors()
    local darkBg = "#191a21"

    return {
      italic_comment = true,
      overrides = {
	Normal = { bg = darkBg },
	FloatBorder = { fg = c.comment, bg = c.bg },
      }
    }

  end,
  init = function()
    vim.cmd([[ colorscheme dracula ]])
  end,
}
