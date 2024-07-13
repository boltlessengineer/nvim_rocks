---@class bt.util
---@field notify bt.util.notify
---@field highlights bt.util.highlights
---@field format bt.util.format
local M = {}
setmetatable(M, {
    __index = function(t, k)
        t[k] = require("utils." .. k)
        return t[k]
    end,
})

---@param ms number
---@param fn function
---@return function
function M.debounce(ms, fn)
    local timer = vim.uv.new_timer()
    return function(...)
        local argv = {...}
        timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
        end)
    end
end

---@param client vim.lsp.Client
function M.lazydev_is_not_working(client)
    local path = vim.tbl_get(client,"workspace_folders", 1, "name")
    if not path then
        vim.print("no workspace")
        return
    end
    client.settings = vim.tbl_deep_extend('force', client.settings, {
        Lua = {
            runtime = {
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
            }
        }
    })
end

return M
