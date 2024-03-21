local k = vim.keymap.set
local c = require("spyglass.configs")

-- TODO:
-- Make separate plugin
-- Make <leader>r not open this somehow?
-- New: new version of TODO Telescope with nicer formatting
-- New: replace easypick by implementing git helpers
-- New: the output of :highlight
-- New: basic git commands on <C-g>

k("n", "<leader>G", c.gitsigns, { desc = "Gitsigns" })
-- TODO: rebind what was <leader>d before
k("n", "<leader>d", c.ts_tools, { desc = "TS Tools" })
