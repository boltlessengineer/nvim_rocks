require("luasnip.session.snippet_collection").clear_snippets("norg")

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local k = require("luasnip.nodes.key_indexer").new_key
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

local function today_fn()
    return os.date("!%Y-%m-%dT%H:%M:%S+00:00")
end

local function file_index_fn(_, snip)
    local filename = vim.fn.expand("%:t:r")
    local title
    -- TODO: rewrite this with `vim.fs` lua api
    if filename == "index" then
        title = vim.fn.expand("%"):match("([^/]+)/[^/]+$")
    else
        title = vim.fn.substitute(snip.env.TM_FILENAME, "\\..*$", "", "g")
    end
    return sn(nil, { i(1, title) })
end

-- stylua: ignore
ls.add_snippets("norg", {
    s("!", fmt(
        [[
            @document.meta
            title: {}
            created: {}
            updated: {}
            @end

            * {}

        ]],
        {
            d(1, file_index_fn),
            f(today_fn, {}, { key = "today" }),
            rep(k"today"),
            rep(1),
            -- t"",
            -- t"",
        }
    )),
})
