require("rocks-setup")
vim.g.rocks_nvim={
    _log_level = vim.log.levels.INFO
}
if vim.fn.has('mac') == 1 then
    vim.g.rocks_nvim = vim.tbl_deep_extend("force", vim.g.rocks_nvim, {
        luarocks_config = {
            arch = "macosx-aarch64"
        }
    })
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

local ok, kulala = pcall(require, "kulala")
if ok then
    kulala.setup()
end
