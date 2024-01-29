return {
	-- FIXME: Causes standalone js to load VERY slow
	-- Crashes sometimes... still?
	"laytan/tailwind-sorter.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
	},
	-- Takes a while to build on install/update, and if build is cancelled must reinstall
	build = "cd formatter && npm i && npm run build",
	config = true,
}
