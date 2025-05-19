-- UNIVERSAL

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
    require("mini.files").open()
end)

-- ╭──────────────────────────────────────────────────────────────────────────────╮
-- │                                   FIND                                       │
-- ╰──────────────────────────────────────────────────────────────────────────────╯
vim.keymap.set("n", "<leader>ff", function()
    require("fzf-lua").git_files({ show_untracked = true })
end, { noremap = true, desc = "Search git files including untracked" })

vim.keymap.set("n", "<leader>fF", function()
    require("fzf-lua").files({ fd_opts = "--hidden --no-ignore --type f --type d" })
end, { noremap = true, desc = "Search all files including hidden" })

vim.keymap.set("n", "<leader>fw", function()
    require("fzf-lua").grep_curbuf()
end, { noremap = true, desc = "Search word in current buffer" })

vim.keymap.set("n", "<leader>fd", function()
    require("fzf-lua").diagnostics()
end, { noremap = true, desc = "Search diagnostics" })

vim.keymap.set("n", "<leader>fg", function()
    require("fzf-lua").live_grep({
        rg_opts = "--hidden --no-ignore --glob '!*.git/*' -i -g '!node_modules/*'",
    })
end, { noremap = true, desc = "Search word in project" })

vim.keymap.set("n", "<leader>fS", function()
    require("fzf-lua").lsp_workspace_symbols()
end, { noremap = true, desc = "Search workspace symbols" })

vim.keymap.set("n", "<leader>fs", function()
    require("fzf-lua").lsp_document_symbols()
end, { noremap = true, desc = "Search document symbols (current buffer)" })

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
