-- No more helpfiles opening in splits. No more tabs either.
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function(event)
    local type = vim.bo[event.buf].filetype

    if type == "help" or type == "markdown" or type == "text" then
      vim.bo.buflisted = true -- Unhide from buffer list
      vim.cmd.only() -- Put in own buffer
    end

    local tabs_open = vim.fn.tabpagenr("$")
    local file_path = vim.fn.bufname(event.buf)

    -- If a tab has appeared, close it and re-open the file normally
    if tabs_open > 1 then
      vim.defer_fn(function()
        vim.cmd("tabclose")
        vim.api.nvim_set_current_buf(event.buf)
      end, 10) -- Delay allows state to stabilise after tab open. Fixes bug where all buffers unfocus.
    end
  end,
})
