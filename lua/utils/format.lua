local Util = require("utils")

---@class bt.util.format
local M = {}

---@param buf? number
---@return boolean
function M.enabled(buf)
    buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf

    -- autoformat options fallback. buffer > editorconfig > global
    -- stylua: ignore
    return vim.F.if_nil(
        vim.b[buf].autoformat,
        vim.b[buf].editorconfig_autoformat,
        vim.g.autoformat
    )
end

function M.toggle()
    -- TODO: if editorconfig says autoformat in that buffer is enabled,
    -- disable it with buffer-local variable
    if vim.b.editorconfig_autoformat ~= nil or vim.b.autoformat ~= nil then
        vim.b.autoformat = not M.enabled()
    else
        vim.g.autoformat = not M.enabled()
        vim.b.autoformat = nil
    end
    M.info()
end

---@param buf? number
function M.info(buf)
    buf = buf or vim.api.nvim_get_current_buf()
    Util.notify.info({
        ("* Status *%s*"):format(M.enabled(buf) and "enabled" or "disabled"),
        ("- (%s) global"):format(vim.g.autoformat and "x" or " "),
        ("- (%s) editorconfig"):format(vim.b[buf].editorconfig_autoformat and "x" or " "),
        ("- (%s) buffer"):format(vim.b[buf].autoformat and "x" or " "),
    })
end

function M.setup()
    vim.g.autoformat = false
    -- Autoformat autocmd
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("AutoFormat", {}),
        callback = function(event)
            if M.enabled(event.buf) then
                require("conform").format({
                    lsp_fallback = true,
                    async = false,
                })
            end
        end,
    })

    vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
            range = {
                start = { args.line1, 0 },
                ["end"] = { args.line2, end_line:len() },
            }
        end

        local ok = require("conform").format({
            lsp_fallback = true,
            async = true,
            range = range,
        })
        -- TODO: check that ranged-format failed
        if not ok then
            Util.notify.warn("No formatter available", { title = "Formatter" })
        end
    end, {
        desc = "Format selection or buffer",
        range = true,
    })

    vim.api.nvim_create_user_command("FormatInfo", function()
        M.info()
    end, { desc = "Show info about the formatters for the current buffer" })

    vim.api.nvim_create_user_command("FormatToggle", function()
        M.toggle()
    end, { desc = "Toggle autoformat option" })
end
return M
