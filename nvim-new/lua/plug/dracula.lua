return {
  "Mofiqul/dracula.nvim",
  opts = {
    italic_comment = true,
    overrides = function()
      local darkBg = "#191a21"

      return { Normal = { bg = darkBg } }
    end,
  },
  init = function() vim.cmd([[ colorscheme dracula ]]) end,
}
