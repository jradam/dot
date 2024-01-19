return {
	"lewis6991/satellite.nvim",
	config = function()
		-- This plugin crashes often but is very useful - pcall ignores the crashes
		local status, satellite = pcall(require, "satellite")
		if status then
			---@diagnostic disable-next-line: missing-fields
			satellite.setup({ current_only = true })
		else
			print("Failed to load satellite.nvim")
		end
	end,
}
