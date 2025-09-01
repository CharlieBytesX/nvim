return {
    "ibhagwan/fzf-lua",
    config = function()
        require("fzf-lua").setup {
            keymap = {
                fzf = {
                    ["ctrl-q"] = "select-all+accept",
                },
            },
        }
    end,
}
