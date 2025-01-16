require("luasnip.session.snippet_collection").clear_snippets("all")

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local r = ls.restore_node

local function pair(pair_begin, pair_end)
    -- autopair implementation inspired by Luasnip wiki
    -- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all---pairs
    return s({ trig = pair_begin, wordTrig = false }, {
        t({ pair_begin }),
        c(1, {
            r(1, "content", i(1)),
            sn(nil, { t({ "", "\t" }), r(1, "content", i(1)), t({ "", "" }) }),
        }),
        t({ pair_end }),
    })
end

ls.add_snippets("all", {
    pair("(", ")"),
    pair("{", "}"),
    pair("[", "]"),
    pair("<", ">"),
    pair("'", "'"),
    pair('"', '"'),
    pair("`", "`"),
})
