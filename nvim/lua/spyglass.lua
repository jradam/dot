local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- TODO: Separate this into own plugin

local function get_labels(option_table)
  local labels = {}
  for index, option in ipairs(option_table) do
    labels[index] = option.label
  end
  return labels
end

local function get_cmd(option_table, label)
  for _, option in ipairs(option_table) do
    if option.label == label then
      option.value = not option.value
      return option.cmd
    end
  end
end

local state = require("gitsigns.config").config
local option_table = {
  {
    label = state.numhl and "Turn gitsigns off" or "Turn gitsigns on",
    cmd = "Gitsigns toggle_numhl",
  },
  {
    label = state.show_deleted and "Turn deleted off" or "Turn deleted on",
    cmd = "Gitsigns toggle_deleted",
  },
  {
    label = state.current_line_blame and "Turn blame off" or "Turn blame on",
    cmd = "Gitsigns toggle_current_line_blame",
  },
  {
    label = state.base == "main" and "Switch to head" or "Switch to main",
    cmd = "Gitsigns "
      .. (
        state.base == "main" and "change_base HEAD true"
        or "change_base main true"
      ),
  },
}

local spyglass = function(name, commands)
  local action = function(bufnr)
    actions.select_default:replace(function()
      local selection = action_state.get_selected_entry()
      local cmd = get_cmd(commands, selection.value)

      vim.cmd(cmd)
      actions.close(bufnr)
    end)

    return true
  end

  local type = require("telescope.themes").get_dropdown()

  pickers
    .new(type, {
      prompt_title = name,
      finder = finders.new_table(get_labels(commands)),
      sorter = conf.generic_sorter(),
      attach_mappings = action,
    })
    :find()
end

spyglass("Gitsigns", option_table)
