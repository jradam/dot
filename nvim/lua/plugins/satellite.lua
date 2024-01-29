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

-- FIXME: When this breaks again, try some of this:
-- The :SatelliteDisable command disables scrollbars.
-- The :SatelliteEnable command enables scrollbars. This is only necessary if scrollbars have previously been disabled.
-- The :SatelliteRefresh command refreshes the scrollbars. This is relevant when the scrollbars are out-of-sync, which can occur as a result of some window arrangement actions.
