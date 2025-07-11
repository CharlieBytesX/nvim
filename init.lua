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
        require "plugins.blink",
        { "nvim-treesitter/nvim-treesitter-context", config = true },

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
vim.lsp.enable "eslint"
vim.lsp.enable "yamlls"
vim.lsp.enable "rust_analyzer"

-- vim.lsp.enable "denols"
