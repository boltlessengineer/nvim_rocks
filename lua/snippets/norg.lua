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

local DATE_FORMAT = "!%Y-%m-%dT%H:%M:%S+09:00"

local function today_fn()
    return os.date(DATE_FORMAT)
end

-- TODO: reimplement these with git
local function btime_fn()
    local path = vim.fn.expand("%")
    local stat = vim.uv.fs_stat(path)
    local btime = stat.birthtime or stat.mtime
    btime = btime.sec
    return os.date(DATE_FORMAT, btime)
end

local function mtime_fn()
    local path = vim.fn.expand("%")
    local stat = vim.uv.fs_stat(path)
    local mtime = stat.mtime
    mtime = mtime.sec
    return os.date(DATE_FORMAT, mtime)
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
    title = vim.fn.substitute(title, "-", " ", "g")
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

        ]],
        {
            d(1, file_index_fn),
            f(btime_fn),
            f(mtime_fn),
            -- t"",
            -- t"",
        }
    )),
})
