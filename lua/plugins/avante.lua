return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
        -- add any opts here
        -- for example
        -- provider = "openai",
        -- openai = {
        --     endpoint = "https://api.openai.com/v1",
        --     model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
        --     timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
        --     temperature = 0,
        --     max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
        --     --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
        -- },
        providers = {
            deepseek = {
                __inherited_from = "openai",
                api_key_name = "DEEPSEEK_API_KEY",
                endpoint = "https://api.deepseek.com",
                model = "deepseek-coder",
            },
        },

        --       provider = "lmstudio",
        --       vendors = {
        --           lmstudio = {
        --               __inherited_from = "openai",
        --               api_key_name = "",
        --               endpoint = "http://10.1.200.27:1234/v1",
        --               model = "phi-3.1-mini-128k-instruct",
        -- max_tokens =5078
        --           },
        --       },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "echasnovski/mini.pick", -- for file_selector provider mini.pick
        -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua", -- for file_selector provider fzf
        -- "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        -- "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
        {
            -- Make sure to set this up properly if you have lazy=true
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
