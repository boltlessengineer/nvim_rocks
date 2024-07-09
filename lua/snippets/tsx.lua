require("luasnip.session.snippet_collection").clear_snippets("typescriptreact")

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local fn = ls.function_node
local dn = ls.dynamic_node
local sn = ls.snippet_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

-- Get a list of  the property names given an `interface_declaration`
-- treesitter *tsx* node.
-- Ie, if the treesitter node represents:
--   interface {
--     prop1: string;
--     prop2: number;
--   }
-- Then this function would return `{"prop1", "prop2"}
---@param node TSNode interface declaration node
---@return string[]
local function get_prop_names(node)
    local interface_body = node:field("body")[1]
    if not interface_body then
        return {}
    end

    local prop_names = {}

    for prop_signature in interface_body:iter_children() do
        if prop_signature:type() == "property_signature" then
            local prop_iden = prop_signature:child(0)
            local prop_name = vim.treesitter.get_node_text(prop_iden, 0)
            prop_names[#prop_names + 1] = prop_name
        end
    end

    return prop_names
end

-- original: https://gist.github.com/davidatsurge/9873d9cb1781f1a37c0f25d24cb1b3ab
-- https://www.reddit.com/r/neovim/comments/uuhk1t/feedback_on_luasniptreesitter_snippet_that_fills/
local componentWithProps = fmta(
    [[
        <>interface <>Props {
        <><>
        }

        export function <>({ <> }: <>Props) {
        <>return <>;
        };
    ]],
    {
        c(1, { t "export ", t "" }),
        -- Initialize component name to file name
        rep(3),
        t "\t",
        i(2, "// Props"),
        dn(3, function(_, snip)
            local filename = vim.fn.expand("%:t:r")
            local comp_name
            -- TODO: rewrite this with `vim.fs` lua api
            if filename == "index" then
                comp_name = vim.fn.expand("%"):match("([^/]+)/[^/]+$")
            else
                comp_name = vim.fn.substitute(snip.env.TM_FILENAME, "\\..*$", "", "g")
            end
            return sn(nil, { i(1, comp_name) })
        end, { 1 }),
        fn(function(_, snip, _)
            local pos_begin = snip.nodes[4].mark:pos_begin()
            local pos_end = snip.nodes[4].mark:pos_end()
            local parser = vim.treesitter.get_parser(0, "tsx")
            local tstree = parser:parse()

            local node = tstree[1]:root():named_descendant_for_range(pos_begin[1], pos_begin[2], pos_end[1], pos_end[2])

            while node ~= nil and node:type() ~= "interface_declaration" do
                node = node:parent()
            end

            if node == nil then
                return ""
            end

            -- `node` is now surely of type "interface_declaration"
            local prop_names = get_prop_names(node)

            return vim.fn.join(prop_names, ", ")
        end, { 2 }),
        rep(3),
        t "\t",
        i(4, "null"),
    }
)

-- stylua: ignore
ls.add_snippets("typescriptreact", {
    s("cp", componentWithProps),
})
