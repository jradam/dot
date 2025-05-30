return {
  "Mofiqul/dracula.nvim",
  opts = {
    italic_comment = true,
    overrides = function(c)
      local darkBg = "#191a21"

      return {
        Normal = { bg = darkBg },
        FloatBorder = { fg = c.comment, bg = c.bg },
      }
    end,
  },
  init = function() vim.cmd([[ colorscheme dracula ]]) end,
}
