-- local leap = require("leap")
-- leap.add_default_mappings(true)
vim.keymap.set('n', 's',  '<Plug>(leap-forward)')
vim.keymap.set('n', 'S',  '<Plug>(leap-backward)')
vim.keymap.set('n', 'gs', '<Plug>(leap-from-window)')
-- vim.keymap.del({ "x", "o" }, "x")
-- vim.keymap.del({ "x", "o" }, "X")
-- vim.keymap.del({ "x" }, "s")
-- vim.keymap.del({ "x" }, "S")
-- vim.keymap.del({ "x", "o" }, "gs")
