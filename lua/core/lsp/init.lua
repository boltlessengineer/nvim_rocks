vim.diagnostic.config({
    underline = true,
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
        linehl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticLineError",
            [vim.diagnostic.severity.WARN] = "DiagnosticLineWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticLineInfo",
            -- [vim.diagnostic.severity.HINT] = "DiagnosticLineHint",
        },
    },
    -- float
    -- update_in_insert
    servirty_sort = true,
})

do
    local ok, lazydev = pcall(require, "lazydev")
    if ok then
        lazydev.setup({
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        })
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user.lspattach", { clear = false }),
    callback = function(ev)
        vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = false })
    end,
})

local ok, lspconfig = pcall(require, "lspconfig")
if not ok then return end

local function setup(server, opts)
    -- NOTE: This isn't perfect, but it should work for 99% of uninstalled servers
    local cmd = lspconfig[server].document_config.default_config.cmd[1]
    if vim.fn.executable(cmd) == 0 then
        return
    end
    opts = opts or {}
    lspconfig[server].setup(opts)
end

for name, opts in pairs(require("core.lsp.servers")) do
    setup(name, opts)
end
