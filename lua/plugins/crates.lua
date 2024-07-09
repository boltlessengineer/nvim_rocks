local crates = require("crates")

crates.setup()

vim.api.nvim_create_autocmd("BufRead", {
    pattern = "Cargo.toml",
    callback = function(ev)
        vim.keymap.set("n", "K", function()
            if crates.popup_available() then
                crates.show_popup()
            end
        end, { silent = true, buffer = ev.buf })
    end,
})
