local Util = require("utils")

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
-- fast indent/dedenting
vim.keymap.set("n", "<", "<<")
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("n", ">", ">>")
vim.keymap.set("x", ">", ">gv")
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
-- vim.keymap.set({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- vim.keymap.set({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- quickfix list
vim.keymap.set("n", "<c-j>", "<cmd>cnext<cr>")
vim.keymap.set("n", "<c-k>", "<cmd>cprev<cr>")

vim.keymap.set("n", "<cs-tab>", "<cmd>tabprev<cr>", { desc = "Prev tab" })
vim.keymap.set("n", "<c-tab>", "<cmd>tabnext<cr>", { desc = "Next tab" })

-- ways to exit select mode without substituting
vim.keymap.set("s", "<left>", "<c-g><c-v>I")
vim.keymap.set("s", "<right>", "<c-g><c-v>A")

-- other useful mappings
vim.keymap.set("x", "J", ":m '>+1<cr>gv=gv", { silent = true, desc = "Move down" })
vim.keymap.set("x", "K", ":m '<-2<cr>gv=gv", { silent = true, desc = "Move up" })

-- diagnostics
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set({ "n", "x" }, "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set({ "n", "x" }, "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
-- stylua: ignore start
vim.keymap.set({ "n", "x" }, "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next Error" })
vim.keymap.set({ "n", "x" }, "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev Error" })
vim.keymap.set({ "n", "x" }, "]w", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end, { desc = "Next Warning" })
vim.keymap.set({ "n", "x" }, "[w", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end, { desc = "Prev Warning" })
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

-- TODO: automate this
local function lsp_not_attached(_command)
    return function()
        Util.notify.warn("lsp not attached")
    end
end
vim.keymap.set("n", "<leader>ca", lsp_not_attached("code_action"))
vim.keymap.set("n", "<leader>cr", lsp_not_attached("rename"))
vim.keymap.set("n", "gd", lsp_not_attached("definition"))
vim.keymap.set("n", "gr", lsp_not_attached("references"))
vim.keymap.set("n", "gy", lsp_not_attached("type_definition"))
vim.keymap.set("n", "gI", lsp_not_attached("implementation"))
vim.keymap.set("n", "gD", lsp_not_attached("declaration"))
vim.keymap.set("i", "<c-k>", lsp_not_attached("signature_help"))
vim.keymap.set("i", "<c-s>", lsp_not_attached("signature_help"))

-- lsp
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = false }),
    callback = function(ev)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf })
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = ev.buf })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf })
        vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { buffer = ev.buf })
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = ev.buf })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf })
        vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help, { buffer = ev.buf })
        vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, { buffer = ev.buf })
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
        vim.keymap.set("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Reset Buffer", buffer = ev.buf })
        vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<cr>", { desc = "Preview Inline", buffer = ev.buf })
        vim.keymap.set("n", "<leader>gP", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview Hunk", buffer = ev.buf })
        vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Blame Line", buffer = ev.buf })
        vim.keymap.set({ "n", "x" }, "<leader>ga", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage Hunk", buffer = ev.buf })
        vim.keymap.set({ "n", "x" }, "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset Hunk", buffer = ev.buf })
    end,
})
--[[
./?.so;/usr/local/lib/lua/5.1/?.so
/home/ubuntu/repo/neovim/.deps/usr/lib/lua/5.1/?.so
/usr/local/lib/lua/5.1/loadall.so
/home/ubuntu/.local/share/nvim_rocks/rocks/lib/lua/5.1/?.so
/home/ubuntu/.local/share/nvim_rocks/rocks/lib64/lua/5.1/?.so

/home/ubuntu/.local/share/nvim_rocks/site/pack/luarocks/opt/tree-sitter-css/parser/css.so

./?.lua
/home/ubuntu/repo/neovim/.deps/usr/share/luajit-2.1/?.lua
/usr/local/share/lua/5.1/?.lua
/usr/local/share/lua/5.1/?/init.lua
/home/ubuntu/repo/neovim/.deps/usr/share/lua/5.1
/?.lua
/home/ubuntu/repo/neovim/.deps/usr/share/lua/5.1/?/init.lua
/home/ubuntu/.local/share/nvim_rocks/rocks/share/lua/5.1/?.lua
/home/ubuntu/.local/share/nvim_rocks/rocks/share/lu
a/5.1/?/init.lua
/run/user/1001/luarocks-E5B7D6D75851B0/share/lua/5.1/?.lua
/run/user/1001/luarocks-E5B7D6D75851B0/share/lua/5.1/init.lua

set packpath?
/home/ubuntu/.config/nvim_rocks
/etc/xdg/nvim_rocks
/home/ubuntu/.local/share/nvim_rocks/site
/usr/local/share/nvim_rocks/site
/usr/share/nvim_rocks/site
/var/lib/snapd/desktop/nvim_rocks/site
/usr/local/share/nvim/runtime
/usr/local/lib/nvim
/var/lib/snapd/desktop/nvim_rocks/site/after
/usr/share/nvim_rocks/site/after
/usr/local/share/nvim_rocks/site/after
/home/ubuntu/.local/share/nvim_rocks/site/after
/etc/xdg/nvim_rocks/after
/home/ubuntu/.config/nvim_rocks/after

/home/ubuntu/.local/share/nvim_rocks/site/pack/luarocks/opt/tree-sitter-css/parser/css.so
--]]
