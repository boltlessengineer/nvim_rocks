require("rocks-setup")
vim.g.rocks_nvim={
    _log_level = vim.log.levels.INFO
}
require("core.keymaps")
require("core.options")
require("core.autocmds")
require("core.highlights")
require("core.ui.statusline")
require("core.lsp")

require("utils.format").setup()
