require("luasnip.session.snippet_collection").clear_snippets("lua")

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local c = ls.choice_node

-- stylua: ignore
ls.add_snippets("lua", {
    s("fn", fmt([[
        function {}({})
        {}{}
        end
    ]], { i(1), i(2), t("\t"), i(3) })),
    s("lfn", fmt([[
        local function {}({})
        {}{}
        end
    ]], { i(1, "name"), i(2), t("\t"), i(3) })),
    s("if", fmt([[
        if {} then
        {}{}
        end
    ]], { i(1), t"\t", i(2) })),
    s("for", {
        t"for ",
        c(1, {
            sn(nil, { i(1, "i"), t" = ", i(2, "1"), t", ", i(3, "10, 1") }),
            sn(nil, { i(1, "key"), t", ", i(2, "value"), t" in pairs(", i(3, "t"), t")" }),
            sn(nil, { i(1, "index"), t", ", i(2, "value"), t" in ipairs(", i(3, "t"), t")" }),
        }),
        t{" do", "\t"},
        i(2),
        t{"", "end"},
    }),
    s("it", fmt([[
        it("{}", function ()
        {}{}
        end)
    ]], { i(1), t("\t"), i(2) }))
})
