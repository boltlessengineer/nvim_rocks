vim.o.foldmethod = "manual"
---@diagnostic disable-next-line: missing-fields
require("ufo").setup({
    provider_selector = function(_bufnr, _filetype, _buftype)
        return { "treesitter" }
    end,
})

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
