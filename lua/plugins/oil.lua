require("oil").setup({
    keymaps = {
        -- TODO: put a small note that I can use `g?` for help
        -- TODO: change `_` opens Oil in util.root()
        -- and make it global keymap
        ["<C-/>"] = "actions.show_help",
        ["<C-s>"] = "actions.select_split",
        ["<C-v>"] = "actions.select_vsplit",
        ["K"] = "actions.preview",
        ["<C-l>"] = "actions.refresh",
        ["<C-.>"] = "actions.toggle_hidden",
        ["-"] = "actions.parent",
        ["_"] = false,
        ["<c-h>"] = false,
        ["<c-p>"] = false,
        ["%"] = function()
            vim.ui.input({ prompt = "Enter filename: " }, function(input)
                vim.cmd.edit(vim.fn.expand("%") .. input)
            end)
        end,
    },
})
