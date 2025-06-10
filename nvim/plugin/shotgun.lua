local function open_all_changed()
  local changed_files = vim.fn.systemlist("git diff --name-only HEAD")
  local untracked_files =
    vim.fn.systemlist("git ls-files --others --exclude-standard")

  local all_files = {}
  if vim.v.shell_error == 0 and #changed_files > 0 then
    for _, file in ipairs(changed_files) do
      table.insert(all_files, file)
    end
  end
  if vim.v.shell_error == 0 and #untracked_files > 0 then
    for _, file in ipairs(untracked_files) do
      table.insert(all_files, file)
    end
  end

  for _, file in ipairs(all_files) do
    vim.cmd("edit " .. vim.fn.fnameescape(file))
  end
end

vim.api.nvim_create_user_command("Shotgun", open_all_changed, {})
