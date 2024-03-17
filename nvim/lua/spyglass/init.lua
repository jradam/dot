local k = vim.keymap.set
local c = require("spyglass.configs")

-- TODO:
-- Make separate plugin
-- Implement `e` to select
-- New: new version of TODO Telescope with nicer formatting
-- New: replace easypick by implementing git helpers
-- New: TSTools menu
-- New: the output of :highlight
-- New: basic git commands on <C-g>

k("n", "<leader>G", c.gitsigns, { desc = "Gitsigns" })
