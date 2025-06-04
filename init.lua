-- ╭──────────────────────────────────────────────────────────────────────────────╮
-- │                        LOAD ENVIRONMENT VARIABLES                         	  │
-- ╰──────────────────────────────────────────────────────────────────────────────╯
local env_file = vim.fn.stdpath "config" .. "/.env"

local function load_env_file(path)
    local file = io.open(path, "r")
    if not file then
        return
    end

    for line in file:lines() do
        local key, val = line:match "^([%w_]+)%s*=%s*(.+)$"
        if key and val then
            vim.fn.setenv(key, val)
        end
    end

    file:close()
end

load_env_file(env_file)

-- ╭──────────────────────────────────────────────────────────────────────────────╮
-- │                          BOOTSTRAP LAZY.NVIM                                │
-- ╰──────────────────────────────────────────────────────────────────────────────╯

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
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

-- ╭──────────────────────────────────────────────────────────────────────────────╮
-- │                          SETUP LAZY.NVIM                                     │
-- ╰──────────────────────────────────────────────────────────────────────────────╯
require("lazy").setup {
    spec = {
        -- PLUGINS
        { "echasnovski/mini.nvim", version = false },
        require("plugins.lsp.init").plugins,
        { "neovim/nvim-lspconfig" },
        require "plugins.formatter",
        { "nvim-treesitter/nvim-treesitter", build = "TSUpdate" },
        { "ellisonleao/gruvbox.nvim" },
        { "ibhagwan/fzf-lua" },
        require "plugins.avante",
        require "plugins.snacks",
        { "windwp/nvim-ts-autotag" },
        {
            "saghen/blink.cmp",
            -- optional: provides snippets for the snippet source
            dependencies = { "rafamadriz/friendly-snippets" },

            -- use a release tag to download pre-built binaries
            version = "1.*",
            -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
            -- build = 'cargo build --release',
            -- If you use nix, you can build from source using latest nightly rust with:
            -- build = 'nix run .#build-plugin',

            ---@module 'blink.cmp'
            ---@type blink.cmp.Config
            opts = {
                -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
                -- 'super-tab' for mappings similar to vscode (tab to accept)
                -- 'enter' for enter to accept
                -- 'none' for no mappings
                --
                -- All presets have the following mappings:
                -- C-space: Open menu or open docs if already open
                -- C-n/C-p or Up/Down: Select next/previous item
                -- C-e: Hide menu
                -- C-k: Toggle signature help (if signature.enabled = true)
                --
                -- See :h blink-cmp-config-keymap for defining your own keymap
                keymap = { preset = "default" },

                appearance = {
                    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                    -- Adjusts spacing to ensure icons are aligned
                    nerd_font_variant = "mono",
                },

                -- (Default) Only show the documentation popup when manually triggered
                completion = { documentation = { auto_show = false } },

                -- Default list of enabled providers defined so that you can extend it
                -- elsewhere in your config, without redefining it, due to `opts_extend`
                sources = {
                    default = { "lsp", "path", "snippets", "buffer" },
                    providers = {
                        snippets = {
                            should_show_items = function(ctx)
                                return ctx.trigger.initial_kind ~= "."
                            end,
                        },
                    },
                },

                -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
                -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
                -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
                --
                -- See the fuzzy documentation for more information
                -- fuzzy = { implementation = "prefer_rust_with_warning" },
                fuzzy = { implementation = "lua" },
            },
            opts_extend = { "sources.default" },
        }, -- {
        --     "echasnovski/mini.snippets",
        --     event = "InsertEnter",
        --     dependencies = {
        --         "rafamadriz/friendly-snippets",
        --     },
        -- },
    },

    -- automatically check for plugin updates
    checker = { enabled = true },
}

-- require("mini.starter").setup()
require("mini.icons").setup()
require("mini.basics").setup()
require("mini.statusline").setup()
require("mini.tabline").setup()
require("mini.keymap").setup()
-- require("mini.pairs").setup()
require("mini.pick").setup()
-- require("mini.animate").setup()
require("mini.indentscope").setup()
require("mini.fuzzy").setup()
-- local gen_loader = require("mini.snippets").gen_loader
-- local lang_patterns = {
--     jsx = { "javascript/javascript.json", "javascript/react-es7.json" },
--     tsx = { "javascript/javascript.json", "javascript/typescript.json", "javascript/react-ts.json" },
-- }
-- require("mini.snippets").setup {
--     snippets = {
--         -- Load custom file with global snippets first (adjust for Windows)
--         gen_loader.from_file "~/.config/nvim/snippets/global.json",
--
--         -- Load snippets based on current language by reading files from
--         -- "snippets/" subdirectories from 'runtimepath' directories.
--         gen_loader.from_lang { lang_patterns = lang_patterns },
--     },
-- }
-- MiniSnippets.start_lsp_server()

require("mini.files").setup {
    mappings = {
        close = "q",
        go_in = "L",
        go_in_plus = "l",
        go_out = "h",
        go_out_plus = "H",
        mark_goto = "'",
        mark_set = "m",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        trim_left = "<",
        trim_right = ">",
    },
}

require("mini.hues").setup { background = "#002734", foreground = "#c0c8cc" } -- azure
-- require "plugins.miniCompletions"
require "plugins.miniClue"

vim.o.termguicolors = true

require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "vimdoc", "python", "rust", "javascript" },
    highlight = { enable = true },
}

--- MAPPINGS
require "mappings"

require("plugins.lsp.init").setup()

require("nvim-ts-autotag").setup {
    opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on trailing </
    },
    -- Also override individual filetype configs, these take priority.
    -- Empty by default, useful if one of the "opts" global settings
    -- doesn't work well in a specific filetype
    -- per_filetype = {
    --     ["html"] = {
    --         enable_close = false,
    --     },
    -- },
}

if vim.fn.has "nvim-0.11" == 1 then
    vim.opt.completeopt:append "fuzzy" -- Use fuzzy matching for built-in completion
end
--ACTIVATE LANGUAGES
vim.lsp.enable "lua_ls"
-- vim.lsp.enable("sith_python")
vim.lsp.enable "pyright"
vim.lsp.enable "ruff"
vim.lsp.enable "typescript-vtsls"
vim.lsp.enable "tailwindcss"
