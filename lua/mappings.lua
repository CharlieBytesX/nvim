-- ╭──────────────────────────────────────────────────────────────────────────────╮
-- │                              General                                         │
-- ╰──────────────────────────────────────────────────────────────────────────────╯
vim.keymap.set(
    { "v", "n" },
    "<C-d>",
    "<C-d>zz",
    { noremap = true, desc = "Half page down and center cursor", silent = true }
)
vim.keymap.set(
    { "v", "n" },
    "<C-u>",
    "<C-u>zz",
    { noremap = true, desc = "Half page up and center cursor", silent = true }
)
vim.keymap.set({ "n" }, "n", "nzz", { noremap = true, desc = "Next result and center", silent = true })
vim.keymap.set({ "n" }, "N", "Nzz", { noremap = true, desc = "Previous result and center", silent = true })
vim.keymap.set({ "n" }, "x", '"_x', { noremap = true, silent = true })

vim.keymap.set({ "v" }, "<", "<gv", { noremap = true, silent = true })
vim.keymap.set({ "v" }, ">", ">gv", { noremap = true, silent = true })

-- Copy selected text to system clipboard
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, desc = "Copy to clipboard" })

vim.keymap.set({ "v" }, "p", '"_dP', { noremap = true, silent = true, desc = "Keep last yanked when pasting" })
-- Paste from system clipboard in normal mode
vim.keymap.set({ "n" }, "<leader>p", '"+p', { noremap = true, desc = "Paste from clipboard" })
vim.keymap.set(
    "v",
    "<leader>p",
    '"_d"+P',
    { noremap = true, silent = true, desc = "Paste from clipboard without overwriting yank" }
)
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, desc = "Copy to clipboard" })

-- ╭──────────────────────────────────────────────────────────────────────────────╮
-- │                            Buffer manipluation                               │
-- ╰──────────────────────────────────────────────────────────────────────────────╯

-- vim.keymap.set({ "n" }, "<Up>", ":resize -2<CR>", { noremap = true, silent = true })
-- vim.keymap.set({ "n" }, "<Down>", ":resize +2<CR>", { noremap = true, silent = true })
-- vim.keymap.set({ "n" }, "<Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
-- vim.keymap.set({ "n" }, "<Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })

vim.keymap.set({ "n" }, "<leader>wv", ":vsplit<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>ws", ":split<CR>", { noremap = true, silent = true })

vim.keymap.set({ "n" }, "<leader>wd", ":close<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>bd", ":bp | bd #<CR>", { noremap = true, silent = true })

-- Closes all other open buffers, leaving only the current one.
vim.keymap.set({ "n" }, "<leader>bo", function()
    -- Get the number of the current buffer.
    local current_buf = vim.api.nvim_get_current_buf()
    -- Get a list of all open buffers.
    local bufs = vim.api.nvim_list_bufs()

    -- Loop through all the buffers.
    for _, buf in ipairs(bufs) do
        -- Check if the buffer is valid and not the current one.
        if vim.api.nvim_buf_is_loaded(buf) and buf ~= current_buf then
            -- Delete the buffer. The { force = true } option prevents an error if there are unsaved changes.
            -- You can remove this option if you want to be prompted for unsaved files.
            vim.api.nvim_buf_delete(buf, { force = false })
        end
    end
    -- Inform the user that the action was successful.
    print "All other buffers closed."
end, { noremap = true, silent = true, desc = "Close Other Buffers" })

-- ╭──────────────────────────────────────────────────────────────────────────────╮
-- │                              TAB NAVIGATION                                  │
-- ╰──────────────────────────────────────────────────────────────────────────────╯
vim.keymap.set("n", "L", "<cmd>bnext<CR>", { noremap = true, desc = "Next buffer" })
vim.keymap.set("n", "H", "<cmd>bprevious<CR>", { noremap = true, desc = "Previous buffer" })
vim.keymap.set("n", "<ESC>", ":nohl<CR>", { noremap = true })

-- ╭──────────────────────────────────────────────────────────────────────────────╮
-- │                                  FILES                                       │
-- ╰──────────────────────────────────────────────────────────────────────────────╯
vim.keymap.set("n", "<leader>e", function()
    local MiniFiles = require "mini.files"
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
end)

-- ╭──────────────────────────────────────────────────────────────────────────────╮
-- │                                   FIND                                       │
-- ╰──────────────────────────────────────────────────────────────────────────────╯
-- vim.keymap.set("n", "<leader>ff", function()
--     require("fzf-lua").git_files({ show_untracked = true })
-- end, { noremap = true, desc = "Search git files including untracked" })

vim.keymap.set("n", "<leader>ff", function()
    require("fzf-lua").files()
end, { noremap = true, desc = "Search files" })

vim.keymap.set("n", "<leader>fF", function()
    require("fzf-lua").files { fd_opts = "--hidden --no-ignore --type f --type d" }
end, { noremap = true, desc = "Search all files including hidden" })

vim.keymap.set("n", "<leader>fw", function()
    require("fzf-lua").grep_curbuf()
end, { noremap = true, desc = "Search word in current buffer" })

vim.keymap.set("n", "<leader>fg", function()
    require("fzf-lua").live_grep {
        rg_opts = "--hidden  --glob '!*.git/*' -i -g '!node_modules/*' -g '!package-lock.json' -g '!bun.lock'",
        silent = true,
    }
end, { noremap = true, desc = "Search word in project" })

vim.keymap.set("n", "<leader>fb", function()
    require("fzf-lua").buffers()
end, { noremap = true, desc = "Search open buffers" })

vim.keymap.set("n", "<leader>fr", function()
    require("fzf-lua").oldfiles()
end, { noremap = true, desc = "Search recent files" })
vim.keymap.set("n", "<leader>fh", function()
    require("fzf-lua").help_tags()
end, { noremap = true, desc = "Search help tags" })

vim.keymap.set("n", "<leader>fm", function()
    require("fzf-lua").marks()
end, { noremap = true, desc = "Search marks" })

vim.keymap.set("n", "<leader>fk", function()
    require("fzf-lua").keymaps()
end, { noremap = true, desc = "Search keymaps" })

------------ HARPOON

vim.keymap.set("n", "<leader>hj", function()
    require("harpoon.ui").toggle_quick_menu()
end, { noremap = true })
vim.keymap.set("n", "<leader>ha", function()
    require("harpoon.mark").add_file()
end, { noremap = true })
vim.keymap.set("n", "<leader>hl", function()
    require("harpoon.ui").nav_next()
end, { noremap = true })
vim.keymap.set("n", "<leader>hh", function()
    require("harpoon.ui").nav_prev()
end, { noremap = true })
vim.keymap.set("n", "<leader>hu", function()
    require("harpoon.ui").nav_file(1) -- navigates to file 3
end, { noremap = true })
vim.keymap.set("n", "<leader>hi", function()
    require("harpoon.ui").nav_file(2) -- navigates to file 3
end, { noremap = true })
vim.keymap.set("n", "<leader>ho", function()
    require("harpoon.ui").nav_file(3) -- navigates to file 3
end, { noremap = true })
vim.keymap.set("n", "<leader>hp", function()
    require("harpoon.ui").nav_file(4) -- navigates to file 3
end, { noremap = true })
---
---

-- vim.keymap.set("n", "<leader>ud", function()
--     -- Check if there are any active diagnostics in the current buffer
--     local current_diagnostics = vim.diagnostic.get(0)
--
--     if #current_diagnostics > 0 then
--         -- If diagnostics are visible, clear them.
--         vim.diagnostic.hide(0)
--         print "Diagnostics hidden for current file."
--     else
--         -- If diagnostics are not visible, show them.
--         vim.diagnostic.show(0)
--         print "Diagnostics shown for current file."
--     end
-- end, { noremap = true, silent = true, desc = "Toggle diagnostics for current file" })
-- p

-- vim.keymap.set("n", "<leader>ud", function()
--     -- Get the current diagnostic configuration
--     local config = vim.diagnostic.config()
--
--     -- Check the current state of 'virtual_text'. The check is safe because we
--     -- will set it to an explicit boolean later.
--     local currently_enabled = config.virtual_text or false
--
--     -- Toggle the state of both virtual text and underline
--     local new_state = not currently_enabled
--     vim.diagnostic.config {
--         virtual_text = new_state,
--         underline = new_state,
--     }
--
--     -- Provide user feedback
--     if new_state then
--         print "Diagnostic visuals enabled for current file."
--     else
--         print "Diagnostic visuals disabled for current file."
--     end
-- end, { noremap = true, silent = true, desc = "Toggle file diagnostics visuals" })

-- [[ Diagnostic Keymaps ]]
-- Toggles for diagnostic UI elements

-- Set the leader key if you haven't already (optional, common practice)
-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Main prefix for all diagnostic toggles
local prefix = "<leader>ud"

-- Hide all diagnostic indicators
keymap("n", prefix .. "h", function()
    vim.diagnostic.config {
        virtual_text = false,
        signs = false,
        underline = false,
    }
    print " Diagnostics hidden"
end, { desc = "Diagnostics: Hide All" })

-- Show all diagnostic indicators
keymap("n", prefix .. "s", function()
    vim.diagnostic.config {
        virtual_text = true,
        signs = true,
        underline = true,
    }
    print " Diagnostics showing all"
end, { desc = "Diagnostics: Show All" })

-- Show only underlines
keymap("n", prefix .. "u", function()
    vim.diagnostic.config {
        virtual_text = false,
        signs = false,
        underline = true,
    }
    print " Diagnostics showing only underline"
end, { desc = "Diagnostics: Show Only Underline" })

-- Show only virtual text (the inline error message)
keymap("n", prefix .. "v", function()
    vim.diagnostic.config {
        virtual_text = true,
        signs = false,
        underline = false,
    }
    print " Diagnostics showing only virtual text"
end, { desc = "Diagnostics: Show Only Virtual Text" })

-- Show only signs (the icons in the gutter)
keymap("n", prefix .. "g", function()
    vim.diagnostic.config {
        virtual_text = false,
        signs = true,
        underline = false,
    }
    print " Diagnostics showing only gutter signs"
end, { desc = "Diagnostics: Show Only Signs (Gutter)" })

-- A useful combination: signs and underlines, but no virtual text
keymap("n", prefix .. "c", function()
    vim.diagnostic.config {
        virtual_text = false,
        signs = true,
        underline = true,
    }
    print " Diagnostics showing signs and underline (combined)"
end, { desc = "Diagnostics: Show Combined (Signs & Underline)" })

vim.api.nvim_set_keymap("n", "<leader>ta", ":$tabnew<CR>", { noremap = true })

vim.api.nvim_set_keymap("n", "<leader>tt", ":tabnew | term<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>tc", ":tabclose<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>to", ":tabonly<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tn", ":tabn<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tp", ":tabp<CR>", { noremap = true })
-- move current tab to previous position
vim.api.nvim_set_keymap("n", "<leader>tmp", ":atabmove<CR>", { noremap = true })
-- move current tab to next position
vim.api.nvim_set_keymap("n", "<leader>tmn", ":+tabmove<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tr", ":Tabby rename_tab ", { noremap = true })

vim.api.nvim_set_keymap("n", "<M-j>", "<cmd>cnext<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<M-k>", "<cmd>cprev<CR>", { noremap = true })

vim.api.nvim_set_keymap("n", "<M-l>", "<cmd>tabn<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<M-h>", "<cmd>tabp<CR>", { noremap = true })

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
