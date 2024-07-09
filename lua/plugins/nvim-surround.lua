require("nvim-surround").setup({
    -- stylua: ignore
    keymaps = {
        insert          = false,
        insert_line     = false,
        normal          = "ys",
        normal_cur      = false,
        normal_line     = false,
        normal_cur_line = false,
        visual          = "s",
        visual_line     = false,
        change          = "cs",
        delete          = "ds",
    },
})
