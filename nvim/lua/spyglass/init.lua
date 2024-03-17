local k = vim.keymap.set
local c = require("spyglass.configs")

-- TODO:
-- Make separate plugin
-- New: new version of TODO Telescope with nicer formatting
-- New: replace easypick by implementing git helpers
-- New: the output of :highlight
-- New: basic git commands on <C-g>

k("n", "<leader>G", c.gitsigns, { desc = "Gitsigns" })
k("n", "<leader>D", c.ts_tools, { desc = "TS Tools" })
