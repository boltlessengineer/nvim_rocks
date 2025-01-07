require("markview").setup({
    initial_state = false,
    callbacks = {
        -- FIX: this is buggy. maybe because it is called *after* enabling
        on_enable = function(_buf, _win)
            vim.cmd("IBLDisable")
        end,
        on_disable = function(_buf, _win)
            vim.schedule(function()
                vim.cmd("IBLEnable")
            end)
        end,
    }
})
