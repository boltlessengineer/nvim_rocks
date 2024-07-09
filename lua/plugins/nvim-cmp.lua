--[[
local cmp = require("cmp")

cmp.setup({
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping(function ()
            if not cmp.visible() then
                cmp.complete()
            else
                cmp.select_next_item()
            end
        end),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-c>"] = cmp.mapping.close(),
        ["<c-y>"] = cmp.mapping.confirm({ select = true }),
    }),
    completion = {
        -- https://github.com/hrsh7th/nvim-cmp/blob/v0.0.1/lua/cmp/config/default.lua#L38
        autocomplete = false,
        -- keyword_pattern = "",
        -- keyword_length = 2,
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        -- { name = "luasnip" },
        { name = "neorg" },
        { name = "path" },
        { name = "crates" },
        { name = "buffer" },
    }),
    -- sorting = {
    --     comparators = {
    --         cmp.config.compare.offset,
    --         cmp.config.compare.exact,
    --         cmp.config.compare.score,
    --         cmp.config.compare.recently_used,
    --         -- require("cmp-under-comparator").under,
    --         cmp.config.compare.kind,
    --         cmp.config.compare.sort_text,
    --         cmp.config.compare.length,
    --         cmp.config.compare.order,
    --     },
    -- },
    formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, item)
            -- local icons = require("config.icons").kinds
            -- if icons[item.kind] then
            --     item.kind = icons[item.kind] .. item.kind
            -- end
            local label = item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, 30)
            if truncated_label ~= label then
                item.abbr = truncated_label .. "…"
            end
            -- stylua: ignore
            item.menu = ({
                nvim_lsp       = "[LSP]",
                luasnip        = "[SNIP]",
                luasnip_choice = "[SNIP]",
                buffer         = "[BUF]",
                path           = "[PATH]",
                emoji          = "[EMOJI]",
                crates         = "[CRATES]",
                npm            = "[NPM]",
                neorg          = "[NEORG]",
                orgmode        = "[ORG]",
                git            = "[GIT]",
            })[entry.source.name]
            return item
        end,
    },
    experimental = {
        ghost_text = false,
    },
})
]]
