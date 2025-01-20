local treesj = require("treesj")
local lang_utils = require("treesj.langs.utils")

---@param parent_kind string
---@param node_kind string
local function splitjoin_attribute_value(parent_kind, node_kind)
    return {
        both = {
            enable = function(tsn)
                return tsn:parent():type() == parent_kind
            end,
        },
        split = {
            format_tree = function(tsj)
                local str = tsj:child(node_kind)
                local words = vim.split(str:text(), " ")
                tsj:remove_child(node_kind)
                for i, word in ipairs(words) do
                    tsj:create_child({ text = word }, i + 1)
                end
            end,
        },
    }
end

treesj.setup({
    use_default_keymaps = false,
    max_join_length = 240,
    langs = {
        html = lang_utils.merge_preset(require("treesj.langs.html"), {
            ["quoted_attribute_value"] = splitjoin_attribute_value("attribute", "attribute_value"),
        }),
        javascript = lang_utils.merge_preset(require("treesj.langs.javascript"), {
            ["string"] = splitjoin_attribute_value("jsx_attribute", "string_fragment"),
        }),
    },
})

vim.keymap.set("n", "<leader>j", treesj.toggle)
