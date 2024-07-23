local Util = require("utils")

local lint = require("lint")

local function if_executable(cmd)
    return vim.fn.executable(cmd) == 1 and { cmd }
end

lint.linters_by_ft = {
    dockerfile = if_executable("hadolint"),
    editorconfig = if_executable("editorconfig-checker"),
    fish = if_executable("fish"),
    lua = if_executable("luacheck"),
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
    callback = Util.debounce(100, function ()
        lint.try_lint()
    end),
})
