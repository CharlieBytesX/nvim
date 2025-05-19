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

vim.keymap.set({ "n" }, "<Up>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<Down>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })

vim.keymap.set({ "n" }, "<leader>wv", ":vsplit<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>ws", ":vsplit<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>wd", ":close<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>bd", ":bp | bd #<CR>", { noremap = true, silent = true })


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
        rg_opts = "--hidden --no-ignore --glob '!*.git/*' -i -g '!node_modules/*'",
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
