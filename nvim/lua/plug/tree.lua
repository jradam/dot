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
      local function multi(node)
        if node.name == '..' then
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

      local function opts(desc)
        return { desc = desc, buffer = bufnr, silent = true, nowait = true }
      end

      k("n", "e", function() multi(api.tree.get_node_under_cursor()) end, opts('Multi'))
      k("n", "d", api.fs.remove, opts("Delete"))
      k("n", "a", api.fs.create, opts("Create"))
      k("n", "c", api.fs.copy.node, opts("Copy"))
      k("n", "p", api.fs.paste, opts("Paste"))
      k("n", "x", api.fs.cut, opts("Cut"))
      k("n", "r", api.fs.rename, opts("Rename"))
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
            ".git"
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
    }
  end
}
