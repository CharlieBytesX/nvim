-- Load env variables from .config/nvim
local env_file = vim.fn.stdpath("config") .. "/.env"

local function load_env_file(path)
    local file = io.open(path, "r")
    if not file then
        return
    end

    for line in file:lines() do
        local key, val = line:match("^([%w_]+)%s*=%s*(.+)$")
        if key and val then
            vim.fn.setenv(key, val)
        end
    end

    file:close()
end

load_env_file(env_file)
-- AI
-- add({
--     source = "yetone/avante.nvim",
--     monitor = "main",
--     depends = {
--         "nvim-treesitter/nvim-treesitter",
--         "stevearc/dressing.nvim",
--         "nvim-lua/plenary.nvim",
--         "MunifTanjim/nui.nvim",
--         "echasnovski/mini.icons",
--     },
--     hooks = {
--         post_checkout = function()
--             vim.cmd("make")
--         end,
--     },
-- })
-- --- optional
-- -- add({ source = 'hrsh7th/nvim-cmp' })
-- -- add({ source = 'zbirenbaum/copilot.lua' })
-- -- add({ source = 'HakonHarnes/img-clip.nvim' })
-- -- add({ source = 'MeanderingProgrammer/render-markdown.nvim' })
--
-- -- later(function() require('render-markdown').setup({...}) end)
-- later(function()
--     -- require('img-clip').setup({...}) -- config img-clip
--     -- require("copilot").setup({...}) -- setup copilot to your liking
--     require("avante").setup({
--         provider = "deepseek",
--         vendors = {
--             deepseek = {
--                 __inherited_from = "openai",
--                 api_key_name = "DEEPSEEK_API_KEY",
--                 endpoint = "https://api.deepseek.com",
--                 model = "deepseek-coder",
--             },
--         },
--     }) -- config for avante.nvim
-- end)
--
--
--
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        { "echasnovski/mini.nvim", version = false },
        {
            "stevearc/conform.nvim",
            opts = {},
        },
        { "mason-org/mason.nvim" },
        {
            "nvim-treesitter/nvim-treesitter",
            build = "TSUpdate",
        },
        { "ellisonleao/gruvbox.nvim" },
        { "ibhagwan/fzf-lua" },
        {
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
                provider = "deepseek",
                vendors = {
                    deepseek = {
                        __inherited_from = "openai",
                        api_key_name = "DEEPSEEK_API_KEY",
                        endpoint = "https://api.deepseek.com",
                        model = "deepseek-coder",
                    },
                },
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
        },

        -- add your plugins here
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})

require("mini.starter").setup()
require("mini.icons").setup()
require("mini.basics").setup()
require("mini.statusline").setup()
require("mini.tabline").setup()
require("mini.keymap").setup()
require("mini.pairs").setup()
require("mini.pick").setup()
require("mini.animate").setup()
require("mini.indentscope").setup()
require("mini.fuzzy").setup()

require("mini.files").setup()

require("mini.completion").setup({
    mappings = {
        -- Force two-step/fallback completions
        force_twostep = "<C-Space>",
        force_fallback = "<A-Space>",

        -- Scroll info/signature window down/up. When overriding, check for
        -- conflicts with built-in keys for popup menu (like `<C-u>`/`<C-o>`
        -- for 'completefunc'/'omnifunc' source function; or `<C-n>`/`<C-p>`).
        scroll_down = "<C-f>",
        scroll_up = "<C-b>",
    },
})
print("ello")

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt", lsp_format = "fallback" },
        -- Conform will run the first available formatter
        javascript = { "prettierd", "prettier", stop_after_first = true },
    },
    format_on_save = function(bufnr)
        -- Disable autoformat on certain filetypes
        local ignore_filetypes = { "sql", "java" }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
            return
        end
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        -- Disable autoformat for files in a certain path
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
            return
        end
        -- ...additional logic...
        return { timeout_ms = 500, lsp_format = "fallback" }
    end,
})

vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

require("mason").setup()

vim.lsp.config["lua_ls"] = {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath("config")
                and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
            then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                    "lua/?.lua",
                    "lua/?/init.lua",
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths
                    -- here.
                    -- '${3rd}/luv/library'
                    -- '${3rd}/busted/library'
                },
            },
        })
    end,
    -- Command and arguments to start the server.
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
        },
    },
}
vim.lsp.enable("lua_ls")

local miniclue = require("mini.clue")
miniclue.setup({
    triggers = {
        -- Leader triggers
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },

        -- Built-in completion
        { mode = "i", keys = "<C-x>" },

        -- `g` key
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },

        -- Marks
        { mode = "n", keys = "'" },
        { mode = "n", keys = "`" },
        { mode = "x", keys = "'" },
        { mode = "x", keys = "`" },

        -- Registers
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },

        -- Window commands
        { mode = "n", keys = "<C-w>" },

        -- `z` key
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
    },

    clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
    },
    window = {
        delay = 0,
        config = {
            row = "auto",
            col = "auto",
            width = "auto",
        },
    },
})

require("mini.hues").setup({ background = "#002734", foreground = "#c0c8cc" }) -- azure

vim.o.termguicolors = true

require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "vimdoc" },
    highlight = { enable = true },
})

--- MAPPINGS
require("mappings")

-- FUNCTIONS
