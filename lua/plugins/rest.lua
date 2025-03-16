---@module 'rest-nvim'

-- require("utils").load_local_parser("http")

---@type rest.Opts
vim.g.rest_nvim = {
    highlight = {
        timeout = 250,
    },
    ui = {
        -- panes = require("rest-nvim.ui.panes.preset.browser"),
    },
    _log_level = vim.log.levels.DEBUG,
}
local ok, browser = pcall(require, "rest-nvim.ui.panes.preset.browser")
if ok then
    vim.g.rest_nvim.ui = browser
end
