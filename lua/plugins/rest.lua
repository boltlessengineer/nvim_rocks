---@module 'rest-nvim'

-- require("utils").load_local_parser("http")

---@type rest.Opts
vim.g.rest_nvim = {
    highlight = {
        timeout = 250,
    },
    _log_level = vim.log.levels.DEBUG,
}
