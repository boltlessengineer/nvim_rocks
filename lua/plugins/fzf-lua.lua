local fzf_lua = require("fzf-lua")

fzf_lua.setup({
    defaults = {
        file_icons = false,
    },
    winopts = {
        fullscreen = true,
        preview = {
            layout = "vertical",
            vertical = "up:75%",
            scrollbar = false,
        },
    },
    keymap = {
        builtin = {
            true,
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
        },
        fzf = {
            ["ctrl-l"] = "toggle-all",
        },
    },
})

local function find_dirs(opts)
    opts = opts or {}
    opts.prompt = "Directories> "
    opts.fn_transform = function(x)
        return fzf_lua.utils.ansi_codes.magenta(x)
    end
    opts.actions = {
        ["default"] = function(selected)
            vim.cmd.edit(selected[1])
        end,
    }
    fzf_lua.fzf_exec("fd --type d", opts)
end

vim.keymap.set("n", "<f1>", "<cmd>FzfLua helptags<cr>")
vim.keymap.set("n", "<leader>p", "<cmd>FzfLua<cr>")
vim.keymap.set("n", "<leader>,", "<cmd>FzfLua buffers<cr>")
vim.keymap.set("n", "<leader>e", "<cmd>FzfLua files<cr>")
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>")
vim.keymap.set("n", "<leader>fo", "<cmd>FzfLua oldfiles<cr>")
vim.keymap.set("n", "<leader>fd", find_dirs)
vim.keymap.set("n", "<leader>sf", "<cmd>FzfLua files<cr>")
vim.keymap.set("n", "<leader>sg", "<cmd>FzfLua live_grep<cr>")
vim.keymap.set("n", "<leader>sk", "<cmd>FzfLua keymaps<cr>")
vim.keymap.set("n", "<leader>sh", "<cmd>FzfLua highlights<cr>")
vim.keymap.set("n", "<leader>gs", "<cmd>FzfLua git_status<cr>")
vim.keymap.set("n", "<leader>gl", "<cmd>FzfLua git_commits<cr>")
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user.lspattach.fzf", { clear = false }),
    callback = function(ev)
        vim.keymap.set("n", "gr/", "<cmd>FzfLua lsp_references<cr>", { buffer = ev.buf })
        vim.keymap.set("n", "<leader>cd", "<cmd>FzfLua lsp_document_symbols<cr>", { buffer = ev.buf })
    end
})
