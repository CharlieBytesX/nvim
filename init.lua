--
-- -- Treesitter
-- later(function()
--     add({
--         source = "nvim-treesitter/nvim-treesitter",
--         -- Use 'master' while monitoring updates in 'main'
--         checkout = "master",
--         monitor = "main",
--         -- Perform action after every checkout
--         hooks = {
--             post_checkout = function()
--                 vim.cmd("TSUpdate")
--             end,
--         },
--     })
--     -- Possible to immediately execute code which depends on the added plugin
--     require("nvim-treesitter.configs").setup({
--         ensure_installed = { "lua", "vimdoc" },
--         highlight = { enable = true },
--     })
-- end)
--
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
                -- Or pull in all of 'runtimepath'.
                -- NOTE: this is a lot slower and will cause issues when working on
                -- your own configuration.
                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                -- library = {
                --   vim.api.nvim_get_runtime_file('', true),
                -- }
            },
        })
    end,
    -- Command and arguments to start the server.
    cmd = { "lua-language-server" },
    -- Filetypes to automatically attach to.
    filetypes = { "lua" },
    -- Sets the "root directory" to the parent directory of the file in the
    -- current buffer that contains either a ".luarc.json" or a
    -- ".luarc.jsonc" file. Files that share a root directory will reuse
    -- the connection to the same LSP server.
    -- Nested lists indicate equal priority, see |vim.lsp.Config|.
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
    -- Specific settings to send to the server. The schema for this is
    -- defined by the server. For example the schema for lua-language-server
    -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
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

vim.o.termguicolors = true
