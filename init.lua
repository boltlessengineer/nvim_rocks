require("rocks-setup")
vim.g.rocks_nvim.experimental_features = {
    "ext_module_dependency_stubs",
}
if vim.fn.has('mac') == 1 then
    vim.g.rocks_nvim.luarocks_config = {
        arch = "macosx-aarch64",
        variables = {
            LUA_DIR = "/nix/store/8438aynxm813i6ksassvgq8bb40f8fln-lua-5.1.5-env",
            LUA_INCDIR = "/nix/store/8438aynxm813i6ksassvgq8bb40f8fln-lua-5.1.5-env/include",
        },
    }
end
require("core.keymaps")
require("core.abbrevs")
require("core.options")
require("core.autocmds")
require("core.commands")
require("core.highlights")
require("core.ui.statusline")
require("core.lsp")

require("utils.format").setup()

require("utils").load_local_parser("norg", "norg")

local query = require("vim.treesitter.query")
local html_script_type_languages = {
    ["importmap"] = "json",
    ["module"] = "javascript",
    ["application/ecmascript"] = "javascript",
    ["text/ecmascript"] = "javascript",
}

---@param match (TSNode|nil)[]
---@param _ string
---@param bufnr integer
---@param pred string[]
---@return boolean|nil
query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
    local capture_id = pred[2]
    local node = match[capture_id]
    if not node then
        return
    end
    local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
    local configured = html_script_type_languages[type_attr_value]
    if configured then
        metadata["injection.language"] = configured
    else
        local parts = vim.split(type_attr_value, "/", {})
        metadata["injection.language"] = parts[#parts]
    end
end, { force = true, all = false })
