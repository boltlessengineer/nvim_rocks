require("markview").setup({
    initial_state = false
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(ev)
        vim.keymap.set("n", "<cr>", "<cmd>Markview toggle<cr>", { buffer = ev.buf })
    end
})
