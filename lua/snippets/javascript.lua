require("luasnip.session.snippet_collection").clear_snippets("javascript")
require("luasnip.session.snippet_collection").clear_snippets("typescript")

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

-- stylua: ignore
ls.add_snippets("javascript", {
    s("fn", fmt([[
        function {}({}) {{
        {}{}
        }}
    ]], { i(1), i(2), t("\t"), i(3) })),
    s("cl", fmt([[
        ({}) => {{
        {}{}
        }}
    ]], { i(1), t("\t"), i(2) })),
})
ls.add_snippets("typescript", {
    s("fn", fmt([[
        function {}({}){} {{
        {}{}
        }}
    ]], { i(1), i(2), i(3), t("\t"), i(4) })),
    s("cl", fmt([[
        ({}) => {{
        {}{}
        }}
    ]], { i(1), t("\t"), i(2) })),
})
