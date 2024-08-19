---@module 'rest-nvim'

vim.opt.rtp:prepend(vim.fs.normalize("$HOME/repo/rest.nvim"))
local parser_dir = "$HOME/.cache/tree-sitter/lib/http.so"
if vim.fn.has("macunix") == 1 then
    parser_dir = "$HOME/Library/Caches/tree-sitter/lib/http.dylib"
end
vim.treesitter.language.add("http", { path = vim.fs.normalize(parser_dir) })
if not vim.treesitter.language.get_lang("http") then
    vim.treesitter.language.register("http", "http")
end

---@type rest.Opts
vim.g.rest_nvim = {
    highlight = {
        timeout = 250,
    },
    _log_level = vim.log.levels.DEBUG,
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = "http",
    callback = function (ev)
        vim.treesitter.start(ev.buf, "http")
    end
})
