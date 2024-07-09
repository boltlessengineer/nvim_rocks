---@class bt.util.notify
local M = {}

---@alias BtNotifyOpts {lang?:string, title?:string, level?:number, once?:boolean}

---@param msg string|string[]
---@param opts? BtNotifyOpts
function M.notify(msg, opts)
    if vim.in_fast_event() then
        return vim.schedule(function()
            M.notify(msg, opts)
        end)
    end

    opts = opts or {}
    if type(msg) == "table" then
        msg = table.concat(
            vim.tbl_filter(function(line)
                return line or false
            end, msg),
            "\n"
        )
    end
    vim.notify(msg, opts.level or vim.log.levels.INFO, {
        title = opts.title or "config",
    })
end

---@param msg string|string[]
---@param opts? BtNotifyOpts
function M.error(msg, opts)
    opts = opts or {}
    opts.level = vim.log.levels.ERROR
    M.notify(msg, opts)
end

---@param msg string|string[]
---@param opts? BtNotifyOpts
function M.info(msg, opts)
    opts = opts or {}
    opts.level = vim.log.levels.INFO
    M.notify(msg, opts)
end

---@param msg string|string[]
---@param opts? BtNotifyOpts
function M.warn(msg, opts)
    opts = opts or {}
    opts.level = vim.log.levels.WARN
    M.notify(msg, opts)
end

return M
