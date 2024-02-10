return {
  "stevearc/conform.nvim",
  opts = function()
    -- Fixes issue with default XDG_RUNTIME_DIR being inaccessible
    local XDG_RUNTIME_DIR = os.getenv("HOME") .. "/.temp-conform"

    -- Toggle formatting on save
    vim.g.should_format = true
    vim.keymap.set("n", "<leader>W", function()
      vim.g.should_format = not vim.g.should_format
      print("Formatting set to " .. tostring(vim.g.should_format))
    end, { desc = "Toggle format" })

    local js_types =
      { "javascript", "javascriptreact", "typescript", "typescriptreact" }

    local format_on_save = function()
      local ft = vim.bo.filetype

      if vim.g.should_format then
        for _, filetype in ipairs(js_types) do
          if ft == filetype then
            -- Run TailwindSort (built-in onsave function crashes frequently)
            vim.api.nvim_command("TailwindSort")

            -- Make LSP formatting (including eslint formatting) always run for JavaScript-types
            return { lsp_fallback = "always" }
          end
        end

        -- Also run TailwindSort for plain html
        if ft == "html" then vim.api.nvim_command("TailwindSort") end

        return { lsp_fallback = true } -- Otherwise, only run if no formatters available
      end
    end

    local formatters_by_ft = {
      json = { "prettierd" },
      lua = { "stylua" },
      markdown = { "prettierd" },
      python = { "autopep8" },
      html = { "prettierd" },
    }
    for _, js_type in ipairs(js_types) do
      formatters_by_ft[js_type] = { "prettierd" }
    end

    return {
      formatters_by_ft = formatters_by_ft,
      format_on_save = format_on_save,
      notify_on_error = false,
      formatters = {
        autopep8 = {
          args = { "--indent-size=2", "-" },
        },
        prettierd = {
          env = {
            XDG_RUNTIME_DIR = XDG_RUNTIME_DIR,
            PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath("config")
              .. "/env/.prettierrc.json",
          },
        },
        stylua = {
          command = "stylua",
          args = {
            "--config-path",
            vim.fn.stdpath("config") .. "/env/.stylua.toml",
            "-",
          },
        },
      },
    }
  end,
}
