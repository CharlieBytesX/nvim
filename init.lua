--
-- ╭──────────────────────────────────────────────────────────────────────────────╮
-- │                        LOAD ENVIRONMENT VARIABLES                         	  │
-- ╰──────────────────────────────────────────────────────────────────────────────╯
--
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
-- │                          OPTIONS                                             │
-- ╰──────────────────────────────────────────────────────────────────────────────╯

vim.o.termguicolors = true
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.winborder = "rounded"
-- vim.o.mouse = ""
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
        require "plugins.theme",
        -- PLUGINS
        { "echasnovski/mini.nvim", version = false },
        require("plugins.lsp.init").plugins,
        { "neovim/nvim-lspconfig" },
        require "plugins.formatter",
        { "nvim-treesitter/nvim-treesitter", build = "TSUpdate" },
        { "ellisonleao/gruvbox.nvim" },
        -- { "ibhagwan/fzf-lua" },
        require "plugins.fzf",
        require "plugins.avante",
        require "plugins.snacks",
        { "windwp/nvim-ts-autotag" },
        require "plugins.blink",
        { "nvim-treesitter/nvim-treesitter-context", config = true },
        {
            "catgoose/nvim-colorizer.lua",
            event = "BufReadPre",
            opts = { -- set to setup table
            },
        },

        {
            "ggandor/leap.nvim",
            config = function()
                require("leap").set_default_mappings()
            end,
        },
        {
            "christoomey/vim-tmux-navigator",
            cmd = {
                "TmuxNavigateLeft",
                "TmuxNavigateDown",
                "TmuxNavigateUp",
                "TmuxNavigateRight",
                "TmuxNavigatePrevious",
            },
            keys = {
                { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", mode = { "n", "i", "v", "s" } },
                { "<c-j>", "<cmd>TmuxNavigateDown<cr>", mode = { "n", "i", "v", "s" } },
                { "<c-k>", "<cmd>TmuxNavigateUp<cr>", mode = { "n", "i", "v", "s" } },
                { "<c-l>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "i", "v", "s" } },
                { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", mode = { "n", "i", "v", "s" } },
            },
        },

        { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
        {
            "rose-pine/neovim",
            name = "rose-pine",
        },

        {
            "allaman/kustomize.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
                -- (optional for better directory handling in "List resources")
                -- "nvim-neo-tree/neo-tree.nvim"
            },
            ft = "yaml",

            -- opts = { enable_lua_snip = true },
        },

        {
            "diogo464/kubernetes.nvim",
            lazy = false,
            opts = {
                -- this can help with autocomplete. it sets the `additionalProperties` field on type definitions to false if it is not already present.
                schema_strict = true,
                -- true:  generate the schema every time the plugin starts
                -- false: only generate the schema if the files don't already exists. run `:KubernetesGenerateSchema` manually to generate the schema if needed.
                schema_generate_always = false,
                -- Patch yaml-language-server's validation.js file.
                patch = true,
                -- root path of the yamlls language server. by default it is assumed you are using mason but if not this option allows changing that path.
                yamlls_root = function()
                    return vim.fs.joinpath(vim.fn.stdpath "data", "/mason/packages/yaml-language-server/")
                end,
            },
        },
        { "tpope/vim-rails" },
        { "folke/tokyonight.nvim" },
        { "ThePrimeagen/harpoon" },

        -- {
        --     "saecki/crates.nvim",
        --     tag = "stable",
        --     config = function()
        --         require("crates").setup {
        --             lsp = {
        --                 enabled = true,
        --                 on_attach = function(client, bufnr)
        --                     -- the same on_attach function as for your other language servers
        --                     -- can be ommited if you're using the `LspAttach` autocmd
        --                 end,
        --                 actions = true,
        --                 completion = true,
        --                 hover = true,
        --             },
        --         }
        --     end,
        -- },

        -- { "sindrets/diffview.nvim" },

        {
            "nanozuki/tabby.nvim",
            config = function()
                local tabby = require "tabby"

                tabby.setup {
                    preset = "active_wins_at_tail",
                    tab = { show_for_all_tabs = true },
                    option = {
                        theme = {
                            fill = "TabLineFill",
                            head = "TabLine",
                            current_tab = "TabLineSel",
                            tab = "TabLine",
                            win = "TabLine",
                            tail = "TabLine",
                        },
                        nerdfont = true,
                        lualine_theme = nil,
                        tab_name = {
                            name_fallback = function(tabid)
                                local current_working_directory = vim.fn.getcwd()
                                return vim.fn.fnamemodify(current_working_directory, ":t")
                            end,
                        },
                        buf_name = { mode = "unique" },
                    },
                }
            end,
        },
    },

    change_detection = { enabled = true, notify = true },
    -- automatically check for plugin updates
    checker = { enabled = false },
}

-- require("mini.starter").setup()
require("mini.icons").setup()
require("mini.basics").setup()
require("mini.statusline").setup()
-- require("mini.tabline").setup()
require("mini.keymap").setup()
-- require("mini.pairs").setup()
require("mini.pick").setup()
-- require("mini.animate").setup()
require("mini.indentscope").setup()
require("mini.fuzzy").setup()
require("colorizer").setup()

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

-- require("mini.hues").setup { background = "#002734", foreground = "#c0c8cc" } -- azure
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
-- vim.lsp.enable "lua_ls"
-- vim.lsp.enable("sith_python")
-- vim.lsp.enable "yamlls"
-- vim.lsp.enable "sorbet"
-- vim.lsp.enable "tailwindcss"
-- vim.lsp.enable "pyright"
-- vim.lsp.enable "bashls"
-- vim.lsp.enable "rust_analyzer"
-- vim.lsp.enable "zls"
-- vim.lsp.enable "svelte"
-- vim.lsp.enable "ruby_lsp"
-- vim.lsp.enable "clangd"
-- vim.lsp.enable "rubocop"

-- vim.lsp.enable "denols"
-- vim.cmd.colorscheme "rose-pine-moon"
--
vim.g.lazyvim_check_order = false

vim.g.lazyvim_disable_welcome = true

vim.lsp.enable "typescript-vtsls"
-- lua/core/autocmds.lua (or wherever you keep your autocommands)
--
vim.o.showtabline = 2

vim.opt.sessionoptions = "curdir,folds,globals,help,tabpages,terminal,winsize"
