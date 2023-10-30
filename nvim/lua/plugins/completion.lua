return {
  "hrsh7th/nvim-cmp",
  version = false,      -- last release is way too old
  lazy = false,
  event = "InsertEnter", -- load on enter insert mode
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "onsails/lspkind.nvim",
    "saadparwaiz1/cmp_luasnip", -- adds snippets to cmp menu
    "zbirenbaum/copilot.lua",
    "zbirenbaum/copilot-cmp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
  },
  opts = function()
    require("copilot").setup()
    require("copilot_cmp").setup()

    -- TODO run `:Copilot auth` on nvim load

    local a = vim.api
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    a.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#50fa7b" })

    vim.keymap.set({ "i", "n" }, "<c-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = "show signature" })

    return {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping.confirm({
          select = false,
          behavior = cmp.ConfirmBehavior.Replace,
        }),
        -- TODO what is this?
        ["<F5>"] = cmp.mapping.confirm({
          select = true,
          behavior = cmp.ConfirmBehavior.Replace,
        }),
        ["<esc>"] = function(fallback)
          if cmp.visible() then
            cmp.mapping.abort()(fallback)
            a.nvim_feedkeys(a.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
          else
            fallback()
          end
        end,
      },
      formatting = {
        fields = { "kind", "abbr" },
        format = lspkind.cmp_format({
          mode = "symbol",
          symbol_map = {
            Copilot = "󰜍",
          },
        }),
      },
      sources = cmp.config.sources({
        { name = "luasnip" },
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "buffer" },
        -- TODO is this working as expected?
        { name = "nvim_lsp_signature_help" },
      }),
      experimental = {
        ghost_text = {
          hl_group = "CompletionGhostText",
        },
      },
      window = {
        completion = {
          scrollbar = false,
          border = "rounded",
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
        documentation = {
          border = "rounded",
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
      },
    }
  end,
}
