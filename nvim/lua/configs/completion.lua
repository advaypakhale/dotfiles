dofile(vim.g.base46_cache .. "cmp")

local cmp = require "cmp"

local options = {
  completion = { completeopt = "menu,menuone" },

  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<Down>"] = cmp.mapping.scroll_docs(-4),
    ["<Up>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),

    ["<Tab>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
    }),

    ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
    }),

    ["<Down>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
        else
            fallback()
        end
    end, { "i", "s" }),

    ["<Up>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
        else
            fallback()
        end
    end, { "i", "s" }),
  },

  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
  },
}

return vim.tbl_deep_extend("force", options, require "nvchad.cmp")
