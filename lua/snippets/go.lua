require("luasnip.session.snippet_collection").clear_snippets("go")

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

-- stylua: ignore
ls.add_snippets("go", {
    s("ife", {
        t{"if err != nil {", ""},
        t"\t", c(1, {
            sn(nil, { t"return ", i(1), t"err" }),
            t"log.Fatalln(err)",
        }),
        t{"", "}"}, i(0),
    }),
})
