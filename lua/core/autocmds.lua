local aug = function(group_name, clear)
    clear = vim.F.if_nil(clear, true)
    return vim.api.nvim_create_augroup(group_name, { clear = clear })
end

local au = vim.api.nvim_create_autocmd

au({ "FocusGained", "TermClose", "TermLeave" }, {
    group = aug("checktime"),
    command = "checktime",
})

-- Highlight on yank
au("TextYankPost", {
    group = aug("highlight_yank"),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Resize splits if window got resized
au("VimResized", {
    group = aug("resize_splits"),
    command = "tabdo wincmd =",
})

-- Go to last location when opening a buffer
au("BufReadPost", {
    group = aug("last_loc"),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exists
au("BufWritePre", {
    group = aug("auto_create_dir"),
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- Set options for terminal buffer
-- Use `BufWinEnter term://*` instead of just `TermOpen`
-- just `TermOpen` isn't enough when terminal buffer is created in background
au({ "TermOpen", "BufWinEnter" }, {
    group = aug("terminal_options"),
    pattern = "term://*",
    callback = function()
        -- I should use `setlocal` than `vim.wo` or `vim.bo`
        -- vim.wo[winid] only works with specific window id
        vim.cmd([[
        setlocal nonu
        setlocal nornu
        setlocal nolist
        setlocal signcolumn=no
        setlocal foldcolumn=0
        setlocal statuscolumn=
        setlocal nocursorline
        setlocal scrolloff=0
        setlocal sidescrolloff=0
        ]])
    end,
})

local ftplugins = aug("ftplugins")

au("FileType", {
    group = ftplugins,
    pattern = { "json", "jsonc" },
    callback = function()
        vim.wo.conceallevel = 0
    end,
})

-- HACK: umm... is this right way..?
au("BufWinEnter", {
    group = ftplugins,
    pattern = "NeogitStatus",
    callback = function()
        vim.wo.foldcolumn = "0"
        vim.wo.statuscolumn = ""
    end,
})

-- prevent editing module files
au("BufNew", {
    group = ftplugins,
    pattern = {
        "node_modules/**",
        vim.fs.joinpath(vim.env.CARGO_HOME or "~/.cargo", "register/**"),
    },
    callback = function(event)
        vim.bo[event.buf].modifiable = false
    end,
})

au("CmdlineEnter", {
    group = aug("auto_hlsearch"),
    callback = vim.schedule_wrap(function()
        vim.cmd.nohlsearch()
    end),
})

if vim.o.inccommand == "split" then
    au("BufEnter", {
        group = aug("fix_quicker_nvim"),
        callback = vim.schedule_wrap(function ()
            if vim.bo.buftype == "quickfix" then
                vim.o.inccommand = "nosplit"
            else
                vim.o.inccommand = "split"
            end
        end)
    })
end
