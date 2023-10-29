return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "mason.nvim", "jose-elias-alvarez/typescript.nvim" },
  opts = function()
    local nls = require("null-ls").builtins.formatting
    local path = os.getenv("HOME") .. "/.config/nvim/.config/"

    -- FIXME null-ls sucks
    -- TODO https://github.com/harrisoncramer/nvim/blob/main/lua/lsp/init.lua

    _G.shouldFormat = true
    local function toggleShouldFormat()
      _G.shouldFormat = not _G.shouldFormat
      print("Formatting is now set to " .. tostring(_G.shouldFormat))
    end

    vim.keymap.set("n", "<leader>W", toggleShouldFormat, { desc = "toggle format" })

    return {
      -- NOTE debugging at ~/.cache/nvim/null-ls.log
      -- debug = true,
      sources = {
        nls.stylua,
        require("typescript.extensions.null-ls.code-actions"),
        nls.prettierd.with({
          env = {
            XDG_RUNTIME_DIR = os.getenv("HOME") .. "/.null-ls-temp",
            PRETTIERD_DEFAULT_CONFIG = vim.fn.expand(path .. ".prettierrc.json"),
          },
        }),
        nls.eslint_d.with({
          env = {
            XDG_RUNTIME_DIR = os.getenv("HOME") .. "/.null-ls-temp",
            ESLINT_D_LOCAL_ESLINT_ONLY = true,
            ESLINT_D_DEFAULT_CONFIG = vim.fn.expand(path .. ".eslintrc.json"),
          },
        }),
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              if _G.shouldFormat then
                vim.lsp.buf.format({ bufnr = bufnr })
              end
            end,
          })

          -- vim.api.nvim_buf_set_keymap(
          --   bufnr,
          --   "n",
          --   "<leader>w",
          --   "<cmd>lua vim.lsp.buf.format()<CR>",
          --   { noremap = true, silent = true }
          -- )
        end
      end,
    }
  end,
}

--
-- local filetypes = {
--   "javascript",
--   "javascriptreact",
--   "typescript",
--   "typescriptreact",
-- }
-- local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
--
-- if vim.tbl_contains(filetypes, filetype) then
-- vim.cmd([[ EslintFixAll ]])
-- end
