require("neogen").setup({
    snippet_engine = "luasnip",
})
vim.api.nvim_set_keymap("n", "<leader>nf", ":Neogen<CR>", { noremap = true, silent = true })
