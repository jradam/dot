return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = function()
    local function nvim_tree_toggle() -- Always fill vertical space on tree toggle
      vim.cmd("NvimTreeToggle")
      local tree_window = require("nvim-tree.view").get_winnr()

      if tree_window then
        local height = vim.api.nvim_get_option_value("lines", {})
        vim.api.nvim_win_set_height(tree_window, height - 3)
      end
    end

    return {
      { "<leader>e", nvim_tree_toggle, desc = "Tree" },
    }
  end,
  opts = function()
    local api = require("nvim-tree.api")
    local k = vim.keymap.set
    local toggle = 0

    local function on_attach(bufnr)
      local function opts(desc)
        return { desc = desc, buffer = bufnr, silent = true, nowait = true }
      end

      local function multi(node)
        if node.name == ".." then
          if toggle == 0 then
            api.tree.expand_all()
            toggle = 1
          else
            api.tree.collapse_all()
            toggle = 0
          end
        else
          api.node.open.edit()
        end
      end

      k(
        "n",
        "e",
        function() multi(api.tree.get_node_under_cursor()) end,
        opts("Multi")
      )
      k("n", "d", api.fs.remove, opts("Delete"))
      k("n", "a", api.fs.create, opts("Create"))
      k("n", "c", api.fs.copy.node, opts("Copy"))
      k("n", "p", api.fs.paste, opts("Paste"))
      k("n", "x", api.fs.cut, opts("Cut"))
      k("n", "r", api.fs.rename, opts("Rename"))

      local function git_jump(direction)
        return function()
          local attempts = 0
          while attempts < 50 do
            if direction == "next" then
              api.node.navigate.git.next()
            else
              api.node.navigate.git.prev()
            end
            local node = api.tree.get_node_under_cursor()
            if not node then break end
            if node.type == "directory" then
              if not node.open then api.node.open.edit() end
            else
              break
            end
            attempts = attempts + 1
          end
        end
      end
      k("n", "<S-j>", git_jump("next"), opts("Next git"))
      k("n", "<S-k>", git_jump("prev"), opts("Prev git"))

      local function open_in_same()
        local node = api.tree.get_node_under_cursor()
        if node and node.type == "file" then
          local status = pcall(function() api.tree.close() end)

          if status then
            local current_buf = vim.api.nvim_get_current_buf()
            local existing_buf = vim.fn.bufnr(node.absolute_path)

            if existing_buf ~= -1 and existing_buf ~= current_buf then
              -- Switch to existing buffer if it exists and is different
              vim.api.nvim_buf_delete(current_buf, { force = false })
              vim.api.nvim_set_current_buf(existing_buf)
            else
              -- Replace current buffer contents
              vim.api.nvim_buf_set_name(current_buf, node.absolute_path)
              vim.api.nvim_buf_call(
                current_buf,
                function() vim.cmd("edit!") end
              )
            end
          else
            -- If fails, it's probably the last open window, so nothing to delete
            vim.api.nvim_command("edit " .. node.absolute_path)
          end
        end
      end

      k("n", "<cr>", open_in_same, opts("Open in same"))
    end

    return {
      on_attach = on_attach,
      view = {
        signcolumn = "no",
        adaptive_size = true,
        float = { enable = true, open_win_config = { col = 0 } },
      },
      actions = {
        expand_all = {
          exclude = {
            "node_modules",
            ".git",
          },
        },
        change_dir = { restrict_above_cwd = true },
      },
      renderer = {
        highlight_git = true,
        icons = { git_placement = "signcolumn" },
        group_empty = true,
      },
      update_focused_file = { enable = true },
      filters = {
        custom = { "^.git$" }, -- Don't show git files in the tree
      },
    }
  end,
}
