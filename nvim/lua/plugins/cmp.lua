return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip", -- Snippet engine
    "saadparwaiz1/cmp_luasnip", -- Adds snippets to cmp
    "onsails/lspkind.nvim", -- Adds icons
  },
  opts = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    return {
      snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
      sources = cmp.config.sources({
	{ name = "luasnip" },
	{ name = "buffer" },
	{ name = "path" },
      }),
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
	["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
      },
      formatting = {
	fields = { "kind", "abbr" },
	format = lspkind.cmp_format({ mode = "symbol" }),
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





