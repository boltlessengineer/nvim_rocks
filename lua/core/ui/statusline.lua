local function filename()
    local path = vim.fn.expand("%:p:h")--[[@as string]]
    path = path:gsub("oil://", "")
    path = vim.fs.joinpath(path, "") --
         :gsub("^" .. vim.pesc(vim.fs.joinpath(vim.fn.getcwd(0, 0), "")), "")

    local name = vim.fn.expand("%:p:t")--[[@as string]]
    if vim.bo.filetype == "oil" then
        name = path == "" and "." or path
        path = "oil://"
    elseif name == "" then
        name = "[No Name]"
    end
    return path .. name
end

---Show attached LSP clients in `[name1, name2]` format.
---Long server names will be modified. For example, `lua-language-server` will be shorten to `lua-ls`
---Returns an empty string if there aren't any attached LSP clients.
---@return string
local function lsp_status()
    local attached_clients = vim.lsp.get_clients({ bufnr = 0 })
    if #attached_clients == 0 then
        return ""
    end
    local it = vim.iter(attached_clients)
    it:map(function (client)
        local name = client.name:gsub("language.server", "ls")
        return name
    end)
    local names = it:totable()
    return "[" .. table.concat(names, ", ") .. "]"
end

local function tab_size()
    local tabstop = vim.bo.tabstop
    -- local sts = vim.bo.softtabstop
    -- if sts < 0 then
    --     tabsize = vim.bo.shiftwidth
    -- elseif sts == 0 then
    -- else
    -- end
    -- if vim.bo.expandtab then
    -- end
    return "[ts:" .. tabstop .. "]"
end

function _G.statusline()
    return table.concat({
        filename(),
        "%h%w%m%r",
        "%=",
        tab_size(),
        lsp_status(),
        "  ",
        "%-14(%l,%c%V%)",
        "%P",
    }, "")
end

vim.o.statusline = "%{%v:lua._G.statusline()%}"
