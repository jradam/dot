-- https://github.com/exosyphon/example_telescope_extension
-- https://github.com/paopaol/telescope-git-diffs.nvim/blob/main/lua/telescope/_extensions/git_diffs.lua

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function get_label(option)
  return option.label .. " " .. (option.value and option.on or option.off)
end

local function get_labels(option_table)
  local labels = {}
  for index, option in ipairs(option_table) do
    labels[index] = get_label(option)
  end
  return labels
end

local function get_cmd(option_table, label)
  for _, option in ipairs(option_table) do
    if get_label(option) == label then
      option.value = not option.value
      return option.cmd
    end
  end
end

local state = require("gitsigns.config").config
local option_table = {
  {
    label = "Turn gitsigns",
    off = "on",
    on = "off",
    value = state.numhl,
    cmd = "Gitsigns toggle_numhl",
  },
  {
    label = "Turn deleted",
    off = "on",
    on = "off",
    value = state.show_deleted,
    cmd = "Gitsigns toggle_deleted",
  },
  {
    label = "Turn blame",
    off = "on",
    on = "off",
    value = state.current_line_blame,
    cmd = "Gitsigns toggle_current_line_blame",
  },
  {
    label = "Switch to",
    off = "main",
    on = "current",
    value = state.base == "main",
    cmd = "Gitsigns"
      .. " "
      .. (state.base == "main" and "change_base" or "change_base main"),
  },
}

local gitsigns = function(opts)
  opts = opts or {}

  local action = function(bufnr)
    actions.select_default:replace(function()
      local selection = action_state.get_selected_entry()
      local cmd = get_cmd(option_table, selection.value)

      vim.cmd(cmd)
      actions.close(bufnr)
    end)

    return true
  end

  pickers
    .new(opts, {
      finder = finders.new_table({ results = get_labels(option_table) }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = action,
    })
    :find()
end

gitsigns(require("telescope.themes").get_dropdown({}))
