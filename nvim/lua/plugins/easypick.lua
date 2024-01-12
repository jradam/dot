local function get_pickers()
	local easypick = require("easypick")
	local u = require("utilities")

	local hasLocalChanges = #vim.fn.systemlist("git status --porcelain") > 0
	local pickers = {}

	local conflicts = {
		name = "Conflicts",
		command = "git diff --name-only --diff-filter=U --relative",
		previewer = easypick.previewers.file_diff(),
	}
	local local_changes = {
		name = "Local changes",
		command = "git diff --name-only",
		previewer = u.diff_preview(),
	}
	local main_changes = {
		name = "Changed from main",
		command = "git diff --name-only main",
		previewer = u.diff_preview({ base_branch = "main" }),
	}

	if hasLocalChanges then
		table.insert(pickers, local_changes)
	else
		table.insert(pickers, main_changes)
	end

	table.insert(pickers, conflicts)

	return pickers
end

-- TODO: Remove Easypick and implement these in Telescope natively
-- "Telescope allows for making custom pickers and adding them to your configuration. Albeit it can be a little confusing in the beginning, it’s not too hard. The universally supported option however, is utilizing the inbuilt vim.ui.select and to let dressing.nvim handle the bridging to Telescope (or FZF). It works even without plugins and the advantage is you don’t have to learn syntax that is only ever useful for a single plugin."

return {
	"axkirillov/easypick.nvim",
	dependencies = "nvim-telescope/telescope.nvim",
	keys = function()
		local easypick = require("easypick")

		local function load_and_open()
			easypick.setup({ pickers = get_pickers() }) -- Running each time allows dynamic pickers
			vim.cmd("Easypick")
		end

		return {
			{ "<leader>g", load_and_open, desc = "Git telescope" },
		}
	end,
	opts = function()
		local git_toplevel = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
		local current_dir = vim.fn.getcwd()

		if git_toplevel == nil or git_toplevel ~= current_dir then
			return { pickers = { { name = "Not in top level of a Git repository", command = "" } } }
		end

		-- TODO: deleted files can show as green until scrolled past and back again. diff_preview issue? Affects both local and main versions.

		-- TODO: make an Easypick with the output of :highlight

		-- TODO: Make an Easypick for basic git commands on <C-g>

		return { pickers = get_pickers() }
	end,
}
