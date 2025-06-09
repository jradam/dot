local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- TODO:
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

local function spy(name, commands, opts)
  local action = function(bufnr)
    actions.select_default:replace(function()
      local selection = action_state.get_selected_entry()
      local cmd = get_cmd(commands, selection.value)

      -- Close picker and wait to ensure command is run in buffer
      actions.close(bufnr)
      vim.defer_fn(function() cmd() end, 100)
    end)

    return true
  end

  opts = opts or {}
  local defaults = { initial_mode = "normal", layout_config = { width = 0.6 } }
  local config = vim.tbl_deep_extend("force", defaults, opts)

  local type = require("telescope.themes").get_dropdown(config)

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

local function lsp_actions()
  local params = vim.lsp.util.make_range_params(0, "utf-8")
  local context = { only = { "source" }, diagnostics = {}, triggerKind = 1 }
  params = vim.tbl_extend("force", params, { context = context })

  vim.lsp.buf_request(
    0,
    "textDocument/codeAction",
    params,
    function(err, result)
      if err or not result or #result == 0 then
        print("No code actions available")
        return
      end

      local code_actions = {}
      for _, action in ipairs(result) do
        table.insert(code_actions, {
          label = action.title,
          cmd = function()
            if action.edit then
              vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
            end
            if action.command then
              vim.lsp.buf_request(0, "workspace/executeCommand", action.command)
            end
          end,
        })
      end

      spy("LSP Actions", code_actions)
    end
  )
end

vim.keymap.set(
  "n",
  "<leader>d",
  function() lsp_actions() end,
  { desc = "LSP Actions" }
)
