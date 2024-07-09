local Util = require("utils")
local ls = require("luasnip")

vim.snippet.expand = ls.lsp_expand

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.active = function(filter)
    filter = filter or {}
    filter.direction = filter.direction or 1

    -- if filter.direction == 1 then
    --     return ls.expand_or_locally_jumpable()
    -- else
    --     return ls.locally_jumpable(filter.direction)
    -- end
    return ls.locally_jumpable(filter.direction)
end

-- ---@diagnostic disable-next-line: duplicate-set-field
-- vim.snippet.jump = function(direction)
--     if direction == 1 then
--         if ls.expandable() then
--             return ls.expand_or_jump()
--         else
--             return ls.locally_jumpable(1) and ls.jump(1)
--         end
--     else
--         return ls.locally_jumpable(-1) and ls.jump(-1)
--     end
-- end
---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.jump = ls.jump

vim.snippet.stop = ls.unlink_current

ls.config.set_config({
    update_events = "TextChanged,TextChangedI",
    history = true,
    delete_check_events = "InsertLeave",
    ext_opts = {},
})

vim.g.ls_next_choice_map = "<c-j>"

vim.keymap.set({ "i", "s" }, "<c-y>", function()
    if vim.fn.pumvisible() ~= 0 then
        return "<c-y>"
    elseif ls.expandable() then
        vim.schedule(function()
            ls.expand()
        end)
    end
end, { silent = true, expr = true })
vim.keymap.set({ "i", "s" }, vim.g.ls_next_choice_map, function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)
-- vim.keymap.set({ "i", "s" }, "<c-k>", function()
--     if ls.choice_active() then
--         ls.change_choice(-1)
--     end
-- end)

local group = vim.api.nvim_create_augroup("UserLuasnip", { clear = true })
local ns = vim.api.nvim_create_namespace("UserLuasnip")
vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "LuasnipChoiceNodeEnter",
    callback = function()
        local node = ls.session.event_node
        local line = node:get_buf_position()[1]
        vim.api.nvim_buf_set_extmark(0, ns, line, -1, {
            end_line = line,
            end_right_gravity = true,
            right_gravity = false,
            virt_text = { { " " .. vim.g.ls_next_choice_map .. " to toggle ", "LspInfoTip" } },
        })
    end,
})
local function delete_extmarks()
    local extmarks = vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, {})
    for _, extmark in ipairs(extmarks) do
        vim.api.nvim_buf_del_extmark(0, ns, extmark[1])
    end
end
vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "LuasnipChoiceNodeLeave",
    callback = delete_extmarks,
})
vim.api.nvim_create_autocmd("ModeChanged", {
    group = group,
    pattern = "*[isS\19]*:*[^isS\19]*",
    callback = Util.debounce(50, function()
        if vim.fn.mode():match("[^isS\19]") then
            delete_extmarks()
        end
    end),
})

for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/snippets/*.lua", true)) do
    loadfile(ft_path)()
end
