require("conform").setup({
    format = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
    },
    formatters_by_ft = {
        ["lua"] = { "stylua" },
        ["fish"] = { "fish_indent" },
        ["sh"] = { "shfmt" },
        ["javascript"] = { "prettierd" },
        ["javascriptreact"] = { "prettierd" },
        ["typescript"] = { "prettierd" },
        ["typescriptreact"] = { "prettierd" },
        ["vue"] = { "prettierd" },
        ["css"] = { "prettierd" },
        ["scss"] = { "prettierd" },
        ["less"] = { "prettierd" },
        ["html"] = { "prettierd" },
        ["json"] = { "jq" },
        ["jsonc"] = { "prettierd" },
        ["yaml"] = { "prettierd" },
        ["markdown"] = { "prettierd" },
        ["markdown.mdx"] = { "prettierd" },
        ["graphql"] = { "prettierd" },
        ["handlebars"] = { "prettierd" },
        ["nix"] = { "nixfmt" },
        ["swift"] = { "swiftformat" },
        ["rust"] = { "rustfmt", lsp_format = "fallback" },
    },
    formatters = {
        injected = { options = { ignore_errors = true } },
        prettierd = {
            env = {
                -- FIXME: this doesn't work for some reason
                PRETTIERD_DEFAULT_CONFIG = vim.api.nvim_get_runtime_file("externals/prettier/prettierrc.json", false)[1],
            },
        },
    },
})
