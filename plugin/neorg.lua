-- this is not actual Neorg related stuffs.
-- its just a custom scripts mimicing Neorg.

local JOURNAL_PATH = vim.fs.normalize("~/projects/greyrat/journal/")


vim.api.nvim_create_user_command("Journal", function(args)
    if args.fargs[1] == "new" then
        vim.ui.input({ default = os.date("%Y-%m-%d") }, function(input)
            if not input then
                return
            end
            local filepath = vim.fs.joinpath(JOURNAL_PATH, input .. ".norg")
            local today = os.date("!%Y-%m-%dT%H:%M:%S+00:00")
            local lines = {
                "@document.meta",
                "title: " .. input,
                "created: " .. today,
                "updated: " .. today,
                "@end",
                "",
            }
            vim.cmd.edit(filepath)
            local buf = vim.api.nvim_get_current_buf()
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        end)
    end
end, {
    nargs = "*"
})
