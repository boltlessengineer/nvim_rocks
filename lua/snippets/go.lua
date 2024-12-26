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
            sn(nil, { t"return", i(1), t" err" }),
            t"log.Fatalln(err)",
        }),
        t{"", "}"}, i(0),
    }),
    s("fn", fmt([[
        func {}({}){} {{
        {}{}
        }}
    ]], { i(1), i(2), i(3), t("\t"), i(4) })),
    s("cl", fmt([[
        func({}){} {{
        {}{}
        }}
    ]], { i(1), i(2), t("\t"), i(3) })),
    s("me", fmt([[
        func ({}) {}({}){} {{
        {}{}
        }}
    ]], { i(1), i(2), i(3), i(4), t("\t"), i(5) })),

    s("midfn", fmt([[
        func {}(next http.Handler) http.Handler {{
        {}return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {{
        {}{}
        {}}})
        }}
    ]], { i(1, "sampleMiddleware"), t("\t"), t("\t\t"), i(2), t("\t") })),
})
