return {
	"lewis6991/satellite.nvim",
	config = function()
		-- TODO: Does doing it like this fix the constant crashes?
		local status, satellite = pcall(require, "satellite")
		if status then
			---@diagnostic disable-next-line: missing-fields
			satellite.setup({ current_only = true })
		else
			print("Failed to load satellite.nvim")
		end
	end,
}
