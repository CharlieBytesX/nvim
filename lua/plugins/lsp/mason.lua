return {
    {
        "mason-org/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
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
                "laravel_ls",
            },
            automatic_enable = {
                exclude = {
                    "yamlls",
                    -- "ts_ls",
                },
            },
        },
        -- config = function()
        --     require("mason-lspconfig").setup()
        -- end,
        lazy = false,
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
}
