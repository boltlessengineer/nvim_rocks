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
