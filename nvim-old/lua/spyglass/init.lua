local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- TODO:
-- Make separate plugin
-- Make a "recent changes" list - e.g. on main branch without changes, can get a list of files/changes ordered by most recent
-- New: new version of TODO Telescope with nicer formatting
-- New: replace easypick by implementing git helpers
-- New: the output of :highlight
-- New: basic git commands on <C-g>

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

function M.spy(name, commands)
  local action = function(bufnr)
    actions.select_default:replace(function()
      local selection = action_state.get_selected_entry()
      local cmd = get_cmd(commands, selection.value)

      -- Close picker and wait to ensure command is run in buffer
      actions.close(bufnr)
      vim.defer_fn(function() vim.cmd(cmd) end, 100)
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
      cache_picker = false,
    })
    :find()
end

return M
