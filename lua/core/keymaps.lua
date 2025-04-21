local Util = require("utils")

vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode("<cr>")

-- Fix default keymap errors
vim.keymap.set("x", "<c-c>", "<esc>")
-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- Native-like keymaps
-- keymaps that follows native keymap and make it more consistent
vim.keymap.set("n", "-", "<cmd>e %:h<cr>", { desc = "open dir" })

-- Breaking remaps on native keymaps
vim.keymap.set("n", "g/", "gcc", { remap = true })
vim.keymap.set("x", "g/", "gc", { remap = true })
vim.keymap.set("n", "Q", "q")
vim.keymap.set("n", "q", "<cmd>close<cr>")
-- -- fast indent/dedenting
-- vim.keymap.set("n", "<", "<<")
-- vim.keymap.set("x", "<", "<gv")
-- vim.keymap.set("n", ">", ">>")
-- vim.keymap.set("x", ">", ">gv")

-- quickfix list
vim.keymap.set("n", "<c-j>", "<cmd>cnext<cr>")
vim.keymap.set("n", "<c-k>", "<cmd>cprev<cr>")
vim.keymap.set("n", "<c-q>", function()
    local wininfos = vim.fn.getwininfo()
    local is_quickfix_open = vim.iter(wininfos):any(function(info)
        return info.quickfix == 1 and info.loclist ~= 1
    end)
    if is_quickfix_open then
        vim.cmd.cclose()
    else
        vim.cmd.copen()
    end
end)

vim.keymap.set("n", "<cs-tab>", "<cmd>tabprev<cr>", { desc = "Prev tab" })
vim.keymap.set("n", "<c-tab>", "<cmd>tabnext<cr>", { desc = "Next tab" })

-- ways to exit select mode without substituting
vim.keymap.set("s", "<left>", "<c-g><c-v>I")
vim.keymap.set("s", "<right>", "<c-g><c-v>A")

-- other useful mappings
vim.keymap.set("x", "J", ":m '>+1<cr>gv", { silent = true, desc = "Move down" })
vim.keymap.set("x", "K", ":m '<-2<cr>gv", { silent = true, desc = "Move up" })

-- credit: https://www.reddit.com/r/neovim/comments/1k4efz8/comment/mo9t5xq
vim.keymap.set("n", "ycc", function()
    return 'yy' .. vim.v.count1 .. "gcc']p"
end, { remap = true, expr = true })

vim.keymap.set("n", "zh", "string(shiftwidth()) . 'zh'", { expr = true })
vim.keymap.set("n", "zl", "string(shiftwidth()) . 'zl'", { expr = true })

-- diagnostics
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
-- stylua: ignore start
vim.keymap.set({ "n", "x" }, "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })
vim.keymap.set({ "n", "x" }, "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev Diagnostic" })
vim.keymap.set({ "n", "x" }, "]e", function() vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next Error" })
vim.keymap.set({ "n", "x" }, "[e", function() vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev Error" })
vim.keymap.set({ "n", "x" }, "]w", function() vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.WARN }) end, { desc = "Next Warning" })
vim.keymap.set({ "n", "x" }, "[w", function() vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.WARN }) end, { desc = "Prev Warning" })
-- stylua: ignore end

-- format
vim.keymap.set("n", "<leader>cf", "<cmd>Format<cr>", { desc = "Format" })

-- snippets
vim.keymap.set({ "i", "s" }, "<c-l>", function()
    return vim.snippet.active({ direction = 1 }) and vim.snippet.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<c-h>", function()
    return vim.snippet.active({ direction = -1 }) and vim.snippet.jump(-1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<tab>", function()
    return vim.snippet.active({ direction = 1 }) and vim.snippet.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<s-tab>", function()
    return vim.snippet.active({ direction = -1 }) and vim.snippet.jump(-1)
end, { silent = true })

-- lsp
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = false }),
    callback = function(ev)
        vim.keymap.set("n", "grr", vim.lsp.buf.references, { buffer = ev.buf })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf })
        vim.keymap.set("n", "gry", vim.lsp.buf.type_definition, { buffer = ev.buf })
        vim.keymap.set("n", "gri", vim.lsp.buf.implementation, { buffer = ev.buf })
        vim.keymap.set("n", "grd", vim.lsp.buf.declaration, { buffer = ev.buf })
        vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, { buffer = ev.buf })
        vim.keymap.set({ "n", "i" }, "<f2>", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, { buffer = ev.buf })
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "GitAttach",
    callback = function(ev)
        vim.keymap.set({ "x", "o" }, "ih", ":<c-u>Gitsigns select_hunk<cr>", { desc = "Select Hunk", buffer = ev.buf })
        vim.keymap.set({ "x", "o" }, "ah", ":<c-u>Gitsigns select_hunk<cr>", { desc = "Select Hunk", buffer = ev.buf })
        vim.keymap.set({ "n", "x" }, "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next Hunk", buffer = ev.buf })
        vim.keymap.set({ "n", "x" }, "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Prev Hunk", buffer = ev.buf })
        vim.keymap.set("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo Stage Hunk", buffer = ev.buf })
        vim.keymap.set("n", "<leader>gA", "<cmd>Gitsigns stage_buffer<cr>", { desc = "Stage Buffer", buffer = ev.buf })
        vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Stage Buffer", buffer = ev.buf })
        vim.keymap.set("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Reset Buffer", buffer = ev.buf })
        vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<cr>", { desc = "Preview Inline", buffer = ev.buf })
        vim.keymap.set("n", "<leader>gP", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview Hunk", buffer = ev.buf })
        vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Blame Line", buffer = ev.buf })
        vim.keymap.set({ "n", "x" }, "<leader>ga", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage Hunk", buffer = ev.buf })
        vim.keymap.set({ "n", "x" }, "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset Hunk", buffer = ev.buf })
    end,
})
