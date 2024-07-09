local fzf_lua = require("fzf-lua")

fzf_lua.setup({
    winopts = {
        fullscreen = true,
        preview = {
            layout = "vertical",
            vertical = "up:75%",
            scrollbar = false,
        },
    },
    keymap = {},
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
-- { "<plug>(lsp_definitions)", "<cmd>Telescope lsp_definitions<cr>" },
-- { "<plug>(lsp_type_definitions)", "<cmd>Telescope lsp_type_definitions<cr>" },
-- { "<plug>(lsp_references)", "<cmd>Telescope lsp_references<cr>" },
-- { "<plug>(lsp_implementations)", "<cmd>Telescope lsp_implementations<cr>" },
--
--
--
--
-- ["top"]            = "gg",
-- ["bottom"]         = "G",
-- ["half-page-up"]   = ("%c"):format(0x15), -- [[]]
-- ["half-page-down"] = ("%c"):format(0x04), -- [[]]
-- ["page-up"]        = ("%c"):format(0x02), -- [[]]
-- ["page-down"]      = ("%c"):format(0x06), -- [[]]
-- ["line-up"]        = "Mgk",               -- ^Y doesn't seem to work
-- ["line-down"]      = "Mgj",               -- ^E doesn't seem to work
