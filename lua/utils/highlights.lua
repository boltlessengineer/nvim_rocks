---@class bt.util.highlights
local M = {}

-- TODO: fuck. rewrite this sometime
-- dealing with types is way hard then I thought

---@alias HLAttr {from: string, attr: "fg" | "bg", alter: integer}
---@alias float number

---@class HLData
---@field fg? string foreground
---@field bg? string background
---@field sp? string special
---@field blend? integer between 0 and 100
---@field bold? boolean
---@field standout? boolean
---@field underline? boolean
---@field undercurl? boolean
---@field underdouble? boolean
---@field underdotted? boolean
---@field underdashed? boolean
---@field strikethrough? boolean
---@field italic? boolean
---@field reverse? boolean
---@field nocombine? boolean
---@field link? string
---@field default? boolean

---@alias HLAttrName
---| '"fg"'
---| '"bg"'
---| '"sp"'
---| '"blend"'
---| '"bold"'
---| '"standout"'
---| '"underline"'
---| '"undercurl"'
---| '"underdouble"'
---| '"underdotted"'
---| '"underdashed"'
---| '"strikethrough"'
---| '"italic"'
---| '"reverse"'
---| '"nocombine"'
---| '"link"'
---| '"default"'

---@class HLArgs: HLData
---@field fg? string | HLAttr
---@field bg? string | HLAttr
---@field sp? string | HLAttr
---@field clear? boolean clear existing highlight
---@field inherit? string inherit other highlight

local function num_to_hex(color)
    return string.format("#%06X", color)
end

---@param opts? {name?: string, link?: boolean}
---@param ns? integer
---@return vim.api.keyset.hl_info|nil
local function get_hl_as_hex(opts, ns)
    opts = opts or {}
    ns = ns or 0
    opts.link = opts.link ~= nil and opts.link or false
    local hl = vim.api.nvim_get_hl(ns, opts)
    if vim.tbl_isempty(hl) then
        return nil
    end
    hl.fg = hl.fg and num_to_hex(hl.fg)
    hl.bg = hl.bg and num_to_hex(hl.bg)
    return hl
end

---Change the brightness of a color, negative numbers darken and positive ones brighten
---see:
---1. https://stackoverflow.com/q/5560248
---2. https://stackoverflow.com/a/37797380
---@param color string A hex color
---@param percent float a negative number darkens and a positive one brightens
---@return string
function M.tint(color, percent)
    assert(color and percent, "cannot alter a color without specifying a color and percentage")
    local r = tonumber(color:sub(2, 3), 16)
    local g = tonumber(color:sub(4, 5), 16)
    local b = tonumber(color:sub(6), 16)
    if not r or not g or not b then
        return "NONE"
    end
    local blend = function(component)
        component = math.floor(component * (1 + percent))
        return math.min(math.max(component, 0), 255)
    end
    return string.format("#%02x%02x%02x", blend(r), blend(g), blend(b))
end

---Get the value a highlight group whilst handling errors and fallbacks as well as returning a gui value
---If no attribute is specified return the entire highlight table
---in the right format
---@param group string
---@param attribute HLAttrName
---@param fallback string?
---@return string
function M.get(group, attribute, fallback)
    local data = get_hl_as_hex({ name = group })
    local color = (data and data[attribute]) or fallback or "NONE"
    if not color then
        local error_msg =
            string.format("failed to get highlight %s for attribute %s\n%s", group, attribute, debug.traceback())
        local error_title = string.format("Highlight - get(%s)", group)
        vim.schedule(function()
            vim.notify(error_msg, vim.log.levels.ERROR, { title = error_title })
        end)
        return "NONE"
    end
    return color
end

---resolve fg/bg/sp attribute type
---@param hl string | HLAttr
---@param attr string
---@return string
local function resolve_from_attr(hl, attr)
    if type(hl) ~= "table" then
        return hl
    end
    local color = M.get(hl.from, hl.attr or attr)
    color = color == "NONE" and M.get("Normal", hl.attr or attr) or color
    -- TODO: tint color
    return color
end

--- Sets a neovim highlight with some syntactic sugar. It takes a highlight table and converts
--- any highlights specified as `GroupName = {fg = { from = 'group'}}` into the underlying colour
--- by querying the highlight property of the from group so it can be used when specifying highlights
--- as a shorthand to derive the right colour.
--- For example:
--- ```lua
---   M.set({ MatchParen = {fg = {from = 'ErrorMsg'}}})
--- ```
--- This will take the foreground colour from ErrorMsg and set it to the foreground of MatchParen.
--- NOTE: this function must NOT mutate the options table as these are re-used when the colorscheme is updated
---
---@param ns integer
---@param name string
---@param opts HLArgs
---@overload fun(name: string, opts: HLArgs)
function M.set(ns, name, opts)
    if type(ns) == "string" and type(name) == "table" then
        opts, name, ns = name, ns, 0
    end

    local hl = opts.clear and {} or get_hl_as_hex({ name = opts.inherit or name }) or {}
    -- clear cterm
    if not opts.cterm then
        hl.cterm = nil
    end
    for attribute, data in pairs(opts) do
        if attribute ~= "clear" and attribute ~= "inherit" then
            local new_data = resolve_from_attr(data, attribute)
            hl[attribute] = new_data
        end
    end

    -- FIXME: this part
    vim.api.nvim_set_hl(ns, name, hl --[[@as vim.api.keyset.highlight]])
end

---Apply a list of highlights
---@param hls table<string, HLArgs>
---@param namespace integer?
function M.all(hls, namespace)
    for name, args in pairs(hls) do
        M.set(namespace or 0, name, args)
    end
end

---Set window local highlights
---@param name string
---@param win_id number
---@param hls table<string, HLArgs>
function M.set_winhl(name, win_id, hls)
    local namespace = vim.api.nvim_create_namespace(name)
    M.all(hls, namespace)
    vim.api.nvim_win_set_hl_ns(win_id, namespace)
end

---Run `cb()` on `ColorScheme` event.
---This is useful when *color override* code is quite complicate
---@param name string
---@param cb function
function M.plugin_wrap(name, cb)
    cb()
    local augroup_name = name:gsub("^%l", string.upper) .. "HighlightOverrides"
    vim.api.nvim_create_autocmd({ "ColorScheme", "UIEnter" }, {
        group = vim.api.nvim_create_augroup(augroup_name, { clear = true }),
        callback = function()
            -- Defer resetting these highlights to ensure they apply *after* other overrides
            vim.defer_fn(function()
                cb()
            end, 1)
        end,
    })
end

---Apply highlights for a plugin and refresh on colorscheme change
---@param name string plugin name
---@param hls table<string, HLArgs>
function M.plugin(name, hls)
    M.plugin_wrap(name, function()
        M.all(hls)
    end)
end

---Apply highlight to given text
---@param content any
---@param hlgroup string
---@return string
function M.hl_text(content, hlgroup)
    return string.format("%%#%s#%s%%*", hlgroup, content)
end

return M
