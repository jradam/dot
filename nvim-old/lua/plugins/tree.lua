return {
  "nvim-tree/nvim-tree.lua",
  tag = "nvim-tree-v1.7.0", -- FIXME: Latest version breaks my `multi` function
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = function()
    -- Fail without interrupting the user, but log the error
    local function nvim_tree_toggle()
      local _, err = pcall(function()
        vim.cmd("NvimTreeToggle")
        require("utilities").resize_tree() -- Ensure tree fills space, even if window size has changed
      end)
      if err then
        vim.api.nvim_out_write(err)
        print("Cannot toggle the tree")
      end
    end

    return {
      { "<leader>e", nvim_tree_toggle, desc = "Explorer", silent = true },
    }
  end,
  opts = function()
    local function on_attach(bufnr)
      local api = require("nvim-tree.api")
      local u = require("utilities")

      local function opts(desc)
        return {
          desc = desc,
          buffer = bufnr,
          silent = true,
          nowait = true,
        }
      end

      -- Custom
      vim.keymap.set("n", "<Tab>", u.close_unless_last, opts("Close"))
      vim.keymap.set("n", "<Esc>", u.close_unless_last, opts("Close"))
      vim.keymap.set("n", "<CR>", u.open_in_same, opts("Open"))
      vim.keymap.set(
        "n",
        "e",
        function() u.multi(api.tree.get_node_under_cursor()) end,
        opts("Multi")
      )
      vim.keymap.set("n", "d", u.safe_delete, opts("Delete"))

      -- Defaults
      vim.keymap.set("n", "a", api.fs.create, opts("Create"))
      vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
      vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
      vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
      vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
    end

    return {
      on_attach = on_attach,
      view = {
        relativenumber = true,
        signcolumn = "no",
        adaptive_size = true,
        float = {
          enable = true,
          quit_on_focus_loss = false, -- Avoids a startup crash when opening a float
          open_win_config = {
            height = math.floor(vim.api.nvim_win_get_height(0)) - 1,
            row = 0,
            col = 0,
          },
        },
      },
      actions = {
        expand_all = {
          max_folder_discovery = 600,
          exclude = {
            "node_modules",
            ".git",
            ".next",
            ".storybook",
            "dist",
            "build",
            "public",
            "fonts",
            "venv",
            "solved",
            ".expo",
            ".yarn",
            ".github",
            "__pycache__",
            ".obsidian",
          },
        },
        change_dir = { restrict_above_cwd = true },
        open_file = { quit_on_open = true },
      },
      renderer = {
        highlight_git = true,
        icons = {
          git_placement = "signcolumn", -- Hides git icons, as `signcolumn` is not shown
        },
      },
      -- Keep current file highlighted, also refreshes tree so highlight_git stays updated
      update_focused_file = { enable = true },
      filters = {
        custom = { "^.git$" }, -- Don't show git files in the tree
      },
      git = {
        show_on_open_dirs = false,
        ignore = false, -- Stop gitignored files and folders from being hidden
      },
    }
  end,
}
