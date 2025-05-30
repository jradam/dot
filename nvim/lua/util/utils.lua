local M = {}

M.modes = {
  "n", -- Normal
  "v", -- Visual and Select
  "s", -- Select
  "x", -- Visual
  "o", -- Operator-pending
  "!", -- Insert and Command-line
  "i", -- Insert
  "l", -- ":lmap" mappings for Insert, Command-line and Lang-Arg
  "c", -- Command-line
  "t", -- Terminal-Job
}

return M
