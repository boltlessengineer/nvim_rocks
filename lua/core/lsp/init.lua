vim.diagnostic.config({
    underline = true,
    -- virtual_text
    -- signs
    -- float
    -- update_in_insert
    servirty_sort = true,
})

do
    local ok, mason = pcall(require, "mason")
    if ok then
        mason.setup()
    end
end
do
    local ok, lazydev = pcall(require, "lazydev")
    if ok then
        lazydev.setup()
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = false }),
    callback = function(ev)
        if vim.fn.has("nvim-0.11") == 1 then
            vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = false })
        end
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
