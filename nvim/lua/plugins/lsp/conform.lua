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
            -- Make LSP formatting (including eslint formatting) always run for JavaScript-types
            return { lsp_fallback = "always" }
          end
        end

        return { lsp_fallback = true } -- Otherwise, only run if no formatters available
      end

      return false -- Don't format when formatting is disabled
    end

    local formatters_by_ft = {
      json = { "prettierd" },
      lua = { "stylua" },
      markdown = { "prettierd" },
      -- python = { "black" }, -- FIXME: not working
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
        prettierd = {
          env = function()
            local env = {
              XDG_RUNTIME_DIR = XDG_RUNTIME_DIR,
            }

            local has_tailwind = false

            if
              vim.fn.filereadable("tailwind.config.js") == 1
              or vim.fn.filereadable("tailwind.config.ts") == 1
            then
              has_tailwind = true
            end

            -- Check package.json if tailwind config not found
            if
              not has_tailwind and vim.fn.filereadable("package.json") == 1
            then
              local ok, package_json = pcall(
                function()
                  return vim.fn.join(
                    vim.fn.readfile("package.json", "", 1000),
                    "\n"
                  )
                end
              )

              if ok and package_json then
                has_tailwind = string.find(package_json, "tailwindcss") ~= nil
              end
            end

            -- FIXME: Pretter plugin is broken
            if has_tailwind then
              env.PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath("config")
                .. "/env/.prettierrc-no-tw"
            else
              env.PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath("config")
                .. "/env/.prettierrc-no-tw"
            end

            return env
          end,
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
