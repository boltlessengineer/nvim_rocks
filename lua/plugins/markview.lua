require("markview").setup({
    -- on_enable = function ()
    --     pcall(vim.cmd --[[@as function]], "IBLDisable")
    -- end,
    -- on_disable = function ()
    --     pcall(vim.cmd --[[@as function]], "IBLEnable")
    -- end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function (ev)
        vim.keymap.set("n", "<cr>", "<cmd>Markview toggle<cr>", { buffer = ev.bufnr })
    end
})
