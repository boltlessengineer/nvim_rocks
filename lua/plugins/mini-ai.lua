local ai = require("mini.ai")
local ts_gen = ai.gen_spec.treesitter
ai.setup({
    custom_textobjects = {
        -- remove unused default mappings
        ["?"] = false,
        -- override default mappings
        ["f"] = ts_gen({ a = "@function.outer", i = "@function.inner" }, { use_nvim_treesitter = false }),
        -- custom mappings
        -- ["o"] = ts_gen({
        --     a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        --     i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        -- }, {}),
        -- ["c"] = ts_gen({ a = "@class.outer", i = "@class.inner" }),
        -- ["/"] = ts_gen({ a = "@comment.outer", i = "@comment.inner" }),
        ["u"] = ai.gen_spec.function_call(),
        ["U"] = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
    },
    mappings = {
        goto_left = '',
        goto_right = '',
    },
    n_lines = 500,
    silent = false,
})
