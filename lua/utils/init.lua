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

return M
