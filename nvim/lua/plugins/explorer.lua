return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>e", ":NvimTreeToggle<CR>", desc = "explorer", silent = true },
  },
  opts = function()
    local api = require("nvim-tree.api")
    local toggle = 0

    -- TODO stop this opening within floating windows, i.e. Lazy plugin window

    local function multi(node)
      if node.type == nil then
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

    local function close_if_float()
      local tree_view = require("nvim-tree.view")
      local win_config = vim.api.nvim_win_get_config(tree_view.get_winnr())

      if win_config.relative ~= "" then
        api.tree.close()
      end
    end

    local function open_in_same()
      local node = api.tree.get_node_under_cursor()
      if node and node.type == "file" then
        api.tree.close()
        local current_buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_command("bdelete " .. current_buf)
        vim.api.nvim_command("edit " .. node.absolute_path)
      end
    end

    local function on_attach(bufnr)
      local function opts(desc)
        return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Custom
      vim.keymap.set("n", "<tab>", close_if_float, opts("close"))
      vim.keymap.set("n", "<esc>", close_if_float, opts("close"))
      vim.keymap.set("n", "<CR>", open_in_same, opts("open"))
      vim.keymap.set("n", "e", function()
        multi(api.tree.get_node_under_cursor())
      end, opts("multi"))

      -- Defaults
      vim.keymap.set("n", "a", api.fs.create, opts("Create"))
      vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
      vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
      vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
      vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
      vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
    end

    return {
      on_attach = on_attach,
      view = {
        relativenumber = true,
        signcolumn = "no",
        side = "left",
        adaptive_size = true,
        float = {
          enable = true,
          -- TODO how to make this false for first load, but then true after?
          quit_on_focus_loss = false,
          open_win_config = {
            relative = "win",
            border = "rounded",
            height = math.floor(vim.api.nvim_win_get_height(0) * 1) - 2,
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
            ".local",
            ".config",
          },
        },
        change_dir = { restrict_above_cwd = true },
        open_file = { quit_on_open = true },
      },
      renderer = {
        highlight_git = true,
        icons = {
          git_placement = "after",
          glyphs = {
            git = { unstaged = "●", deleted = "" },
          },
        },
      },
      update_focused_file = {
        enable = true,
      },
      filters = {
        dotfiles = false,
        custom = { "^.git$" },
      },
      git = {
        show_on_dirs = true,
        show_on_open_dirs = false,
        ignore = false,
        timeout = 1000,
      },
    }
  end,
  init = function()
    local function open_on_startup(data)
      local directory = vim.fn.isdirectory(data.file) == 1
      if not directory then
        return
      end

      -- change to the directory
      vim.cmd.cd(data.file)

      -- open the tree
      require("nvim-tree.api").tree.open()
    end

    vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_on_startup })
  end,
}
