require("luasnip.session.snippet_collection").clear_snippets("all")

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt

local function prevent_reexpand(_line_to_cursor, matched_trigger)
    local current_node = ls.session.current_nodes[vim.api.nvim_get_current_buf()]
    if not current_node then
        return true
    end
    local is_same_trigger = current_node.parent.snippet.trigger == matched_trigger
    local current_is_0 = current_node.pos == 0
    if not (is_same_trigger and current_is_0) then
        return true
    end
    local node_pos = current_node:get_buf_position()
    local cur_pos = vim.api.nvim_win_get_cursor(0)
    local same_pos = node_pos[1] + 1 == cur_pos[1] and node_pos[2] == cur_pos[2]
    return not same_pos
end

local function create_autopair(open, close)
    return s({
        trig = open .. close,
        wordTrig = false,
    }, {
        t(open),
        c(1, {
            r(1, "content", i(1)),
            sn(nil, { t({ "", "\t" }), r(1, "content", i(1)), t({ "", "" }) }),
        }),
        t(close),
    }, { condition = prevent_reexpand })
end

-- stylua: ignore
ls.add_snippets(nil, {
    create_autopair("(", ")"),
    create_autopair("[", "]"),
    create_autopair("{", "}"),
    create_autopair("(", "),"),
    create_autopair("[", "],"),
    create_autopair("{", "},"),
    s({ trig = '""', wordTrig = false }, { t('"'), i(1), t('"') }, { condition = prevent_reexpand }),
    s({ trig = "''", wordTrig = false }, { t("'"), i(1), t("'") }, { condition = prevent_reexpand }),
    s({ trig = "``", wordTrig = false }, { t("`"), i(1), t("`") }, { condition = prevent_reexpand }),
})

-- autopair code from Luasnip's wiki

local function char_count_same(c1, c2)
    local line = vim.api.nvim_get_current_line()
    -- '%'-escape chars to force explicit match (gsub accepts patterns).
    -- second return value is number of substitutions.
    local _, ct1 = string.gsub(line, "%" .. c1, "")
    local _, ct2 = string.gsub(line, "%" .. c2, "")
    return ct1 == ct2
end

local function even_count(ch)
    local line = vim.api.nvim_get_current_line()
    local _, ct = string.gsub(line, ch, "")
    return ct % 2 == 0
end

local function neg(fn, ...)
    return not fn(...)
end

local function posi()
    return true
end

local function part(fn, ...)
    local args = { ... }
    return function()
        return fn(unpack(args))
    end
end

-- This makes creation of pair-type snippets easier.
local function pair(pair_begin, pair_end, expand_func, ...)
    -- triggerd by opening part of pair, wordTrig=false to trigger anywhere.
    -- ... is used to pass any args following the expand_func to it.
    return s({ trig = pair_begin, wordTrig = false }, {
        t({ pair_begin }),
        c(1, {
            r(1, "content", i(1)),
            sn(nil, { t({ "", "\t" }), r(1, "content", i(1)), t({ "", "" }) }),
        }),
        t({ pair_end }),
    }, {
        condition = expand_func and part(expand_func, part(..., pair_begin, pair_end)),
    })
end

-- FIXME: pair() also doesn't work bc of this case:
-- ```
-- vim.schedule(function (|)
-- end)
-- ```
-- here, I get unwanted autopair (|))
ls.add_snippets(nil, {
    pair("(", ")", neg, char_count_same),
    pair("{", "}", neg, char_count_same),
    pair("[", "]", neg, char_count_same),
    pair("<", ">", neg, char_count_same),
    pair("'", "'", neg, even_count),
    pair('"', '"', neg, even_count),
    pair("`", "`", neg, even_count),
})

ls.add_snippets("all", {
    pair("(", ")"),
    pair("{", "}"),
    pair("[", "]"),
    pair("<", ">"),
    pair("'", "'"),
    pair('"', '"'),
    pair("`", "`"),
})
