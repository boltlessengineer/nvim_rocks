vim.keymap.set("n", "\\", function()
    vim.notify("zeta.autocmd.setup()")
    require("zeta.autocmd").setup()
end)
vim.keymap.set("n", "gy", "<Plug>(zeta-accept)")
vim.keymap.set("i", "<c-g><c-g>", "<esc><Plug>(zeta-accept)")

vim.g.zeta_nvim = {
    _log_level = vim.log.levels.DEBUG,
}
