---@module "lspconfig"

-- HACK: is `@type lspconfig.options` a thing?

---@diagnostic disable: missing-fields
---@type table<string, vim.lsp.ClientConfig>
return {
    astro = {},
    clangd = {},
    cssls = {},
    dartls = {},
    emmet_language_server = {},
    gopls = {},
    hls = {
        settings = {
            haskell = {
                formattingProvider = "ormolu",
                checkProject = true,
            },
        },
    },
    html = {},
    lua_ls = {
        -- on_init = require("utils").lazydev_is_not_working,
        settings = {
            Lua = {
                hint = {
                    enable = true,
                    arrayIndex = "Disable",
                    paramType = false,
                    setType = true,
                },
                completion = {
                    callSnippet = "Replace",
                },
                diagnostics = {
                    unusedLocalExclude = { "_*" },
                    globals = { "vim" },
                },
                format = {
                    enable = false, -- use stylua istead
                },
                workspace = {
                    checkThirdParty = "Disable",
                },
            },
        },
    },
    nil_ls = {
        on_attach = function (client, bufnr)
            -- if bufIsBig(bufnr) then
            client.server_capabilities.semanticTokensProvider = nil
            -- end
        end
    },
    tsserver = {
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = false,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = false,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        },
    },
    sourcekit = {},
    svelte = {},
    ruff_lsp = {},
    rust_analyzer = {
        cargo = {
            buildScripts = {
                -- enable = true,
            },
        },
    },
    -- volar = {
    --     filetypes = {
    --         "javascript",
    --         "typescript",
    --         "javascriptreact",
    --         "typescriptreact",
    --         "vue",
    --         "json",
    --     },
    --     -- on_new_config = function(new_config, new_root_dir)
    --     --   new_config.init_options.typescript.tsdk = "/path/to/tsserver"
    --     -- end
    -- },
    -- yamlls = {
    --     settings = {
    --         yaml = {
    --             on_new_config = function(new_config)
    --                 if require("utils").plugin.has("SchemaStore.nvim") then
    --                     new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
    --                     vim.list_extend(new_config.settings.yaml.schemas, require("schemastore").yaml.schemas())
    --                 end
    --             end,
    --             schemaStore = {
    --                 enable = false,
    --             },
    --         },
    --     },
    -- },
}
