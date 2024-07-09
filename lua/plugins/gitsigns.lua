require("gitsigns").setup({
    on_attach = function()
        vim.api.nvim_exec_autocmds("User", {
            pattern = "GitAttach",
        })
    end,
})
