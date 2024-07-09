require("luasnip.session.snippet_collection").clear_snippets("rust")

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

-- stylua: ignore
ls.add_snippets("rust", {
    s("cl", {
        t"|", i(1), t"|", t" {", i(2), t"}",
    }),
})
