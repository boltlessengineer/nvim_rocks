local Util = require("utils")

local lint = require("lint")

lint.linters_by_ft = {
    dockerfile = { "hadolint" },
    editorconfig = { "editorconfig-checker" },
    fish = { "fish" },
    -- lua = { "luacheck" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
    callback = Util.debounce(100, function ()
        lint.try_lint()
    end),
})
