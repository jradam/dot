return {
  "Mofiqul/dracula.nvim",
  opts = function()
    local darkBg = "#191a21"

    return {
      italic_comment = true,
      overrides = {
	Normal = { bg = darkBg },
      }
    }

  end,
  init = function()
    vim.cmd([[ colorscheme dracula ]])
  end,
}
