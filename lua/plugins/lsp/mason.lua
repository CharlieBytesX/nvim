return {
    {
        "mason-org/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        config = function()
            local ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "tailwindcss",
                "rubocop",
                "pyright",
                "ruff",
                "tailwindcss",
                "eslint",
                "yamlls",
                "rust_analyzer",
                "cssls",
                "ruby_lsp",
                "yamlls",
                "rubocop",
                "sorbet",
                "phpactor",
                "svelte",
                "clangd",
                "zls",
                "bashls",
                "astro",
            }
            local excluded_from_automatic_activation = { "yamlls" }
            require("mason-lspconfig").setup {
                automatic_enable = false,
                ensure_installed = ensure_installed,
            }
            -- transform into array
            local exclude_lookup = {}
            for _, name in ipairs(excluded_from_automatic_activation) do
                exclude_lookup[name] = true
            end

            local filtered_lookup, filtered = {}, {}
            for _, name in ipairs(ensure_installed) do
                if not exclude_lookup[name] and not filtered_lookup[name] then
                    filtered_lookup[name] = true
                    table.insert(filtered, name)
                end
            end
            -- now apply vim.lsp.enable for each
            for _, name in ipairs(filtered) do
                vim.lsp.enable(name)
            end
        end,

        lazy = false,
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
}
