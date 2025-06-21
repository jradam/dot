local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- TODO:
-- Make a "recent changes" list - e.g. on main branch without changes, can get a list of files/changes ordered by most recent. ['git changes', 'local changes', 'git history'] ?
-- New: new version of TODO Telescope with nicer formatting
-- FIXME: This 228 line file cannot C-d!

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
      if option.value == true then
        return option.cmd
      else
        -- TODO: disabled options should be in 'comment' color and not selectable, i.e. cursor should skip over them
        return function() end
      end
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

vim.api.nvim_create_user_command("SpyLspActions", function()
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
end, {})

vim.api.nvim_create_user_command("SpyConflicts", function()
  local ok, conflicts =
    pcall(vim.fn.systemlist, "git status --porcelain | grep '^UU' | cut -c4-")

  if not ok or #conflicts == 0 then
    print("No conflicts found")
    return
  end

  local conflict_actions = {}
  for _, file in ipairs(conflicts) do
    table.insert(conflict_actions, {
      label = file,
      cmd = function() vim.cmd("edit " .. file) end,
    })
  end

  spy("Conflicts", conflict_actions)
end, {})

vim.api.nvim_create_user_command("SpyGit", function()
  local file = vim.fn.expand("%:p")
  local file_rel = file ~= "" and vim.fn.fnamemodify(file, ":~:.") or ""

  -- Check git status
  local staged = vim.fn.systemlist("git diff --cached --name-only")
  local unstaged = vim.fn.systemlist("git diff --name-only")
  local untracked =
    vim.fn.systemlist("git ls-files --others --exclude-standard")

  local file_needs_add = file ~= ""
    and (
      vim.tbl_contains(unstaged, file_rel)
      or vim.tbl_contains(untracked, file_rel)
    )
  local file_staged = file ~= "" and vim.tbl_contains(staged, file_rel)
  local total_unstaged = #unstaged + #untracked

  -- Helper to create action with consistent pattern
  local function action(label, enabled, success_msg, fail_msg, git_cmd)
    return {
      label = label,
      value = enabled,
      cmd = function()
        if enabled then
          vim.fn.system(git_cmd)
          print(success_msg)
        else
          print(fail_msg)
        end
      end,
    }
  end

  local git_actions = {}

  -- Add this file
  local add_label = file == "" and "Add this (no file open)"
    or file_needs_add and "Add this"
    or "Add this (no changes)"
  table.insert(
    git_actions,
    action(
      add_label,
      file_needs_add,
      "Added: " .. vim.fn.expand("%:t"),
      "Nothing to add",
      "git add " .. vim.fn.shellescape(file)
    )
  )

  -- Commit
  local commit_label
  if #staged == 0 then
    commit_label = "Commit (no staged changes)"
  elseif file_staged then
    local others = #staged - 1
    commit_label = others == 0 and "Commit (this)"
      or others == 1 and "Commit (this and 1 other)"
      or "Commit (this and " .. others .. " others)"
  else
    commit_label = #staged == 1 and "Commit 1 file"
      or "Commit " .. #staged .. " files"
  end

  table.insert(git_actions, {
    label = commit_label,
    value = #staged > 0,
    cmd = function()
      if #staged > 0 then
        vim.ui.input({ prompt = "Message: " }, function(input)
          if input and input ~= "" then
            vim.fn.system("git commit -m " .. vim.fn.shellescape(input))
            print("Committed: " .. input)
          end
        end)
      else
        print("No staged changes to commit")
      end
    end,
  })

  -- Add all
  local add_all_label
  local others_count = file_needs_add and total_unstaged - 1 or total_unstaged
  if total_unstaged == 0 then
    add_all_label = "Add all (no changes)"
  elseif others_count == 0 then
    add_all_label = "Add all (only this)"
  elseif file_needs_add then
    add_all_label = others_count == 1 and "Add all (this and 1 other)"
      or "Add all (this and " .. others_count .. " others)"
  else
    add_all_label = others_count == 1 and "Add all (1 other)"
      or "Add all (" .. others_count .. " others)"
  end

  table.insert(
    git_actions,
    action(
      add_all_label,
      total_unstaged > 0,
      "Added all",
      "None to add",
      "git add ."
    )
  )

  spy("Git Actions", git_actions)
end, {})
