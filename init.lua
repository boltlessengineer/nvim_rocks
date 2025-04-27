require("rocks-setup")
vim.g.rocks_nvim.experimental_features = {
    "ext_module_dependency_stubs",
}
if vim.fn.has('mac') == 1 then
    vim.g.rocks_nvim.luarocks_config = {
        arch = "macosx-aarch64",
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

-- local ok, kulala = pcall(require, "kulala")
-- if ok then
--     kulala.setup()
-- end
