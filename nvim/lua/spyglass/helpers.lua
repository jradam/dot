local M = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

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

function M.spyglass(name, commands)
  local action = function(bufnr)
    actions.select_default:replace(function()
      local selection = action_state.get_selected_entry()
      local cmd = get_cmd(commands, selection.value)

      vim.cmd(cmd)
      actions.close(bufnr)
    end)

    return true
  end

  local type = require("telescope.themes").get_dropdown({
    layout_config = {
      width = 0.6,
    },
  })

  pickers
    .new(type, {
      prompt_title = name,
      finder = finders.new_table(get_labels(commands)),
      sorter = conf.generic_sorter(),
      attach_mappings = action,
    })
    :find()
end

return M
