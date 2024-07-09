local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>h", function()
    harpoon:list():add()
end)
vim.keymap.set("n", "<leader><leader>", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<m-1>", function()
    harpoon:list():select(1)
end)
vim.keymap.set("n", "<m-2>", function()
    harpoon:list():select(2)
end)
vim.keymap.set("n", "<m-3>", function()
    harpoon:list():select(3)
end)
vim.keymap.set("n", "<m-4>", function()
    harpoon:list():select(4)
end)
vim.keymap.set("n", "<F4>", function()
    harpoon:list():select(1)
end)
vim.keymap.set("n", "<F5>", function()
    harpoon:list():select(2)
end)
vim.keymap.set("n", "<F6>", function()
    harpoon:list():select(3)
end)
vim.keymap.set("n", "<F7>", function()
    harpoon:list():select(4)
end)
vim.keymap.set("n", "<leader>1", function()
    harpoon:list():select(1)
end)
vim.keymap.set("n", "<leader>2", function()
    harpoon:list():select(2)
end)
vim.keymap.set("n", "<leader>3", function()
    harpoon:list():select(3)
end)
vim.keymap.set("n", "<leader>4", function()
    harpoon:list():select(4)
end)

-- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "harpoon",
    callback = function(ev)
        vim.keymap.set("n", "<c-c>", "<cmd>q<cr>", { buffer = ev.buf })
    end,
})
