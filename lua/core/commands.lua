vim.api.nvim_create_user_command("LspDetach", function (arg)
    local buf = vim.api.nvim_get_current_buf()
    local servers = vim.lsp.get_clients({ bufnr = buf })
    local function detach_server(server)
        vim.notify("detaching server '" .. server.name .. "' from current buffer")
        vim.lsp.buf_detach_client(buf, server.id)
    end
    if #servers == 0 then
        vim.notify("no LSP client attached to current buffer", vim.log.levels.WARN)
    elseif #servers == 1 then
        detach_server(servers[1])
    else
        -- TODO: detach all servers when arg.bang is true
        vim.ui.select(servers, {
            prompt = "Select Server to detach",
            format_item = function (server)
                return server.name
            end
        }, detach_server)
    end
end, {
    bang = true,
    desc = "Detach Language Server from current buffer",
})
vim.api.nvim_create_user_command("LspLog", function()
    vim.cmd.edit(vim.lsp.log.get_filename())
end, {
    desc = "Open lsp.log file",
})
