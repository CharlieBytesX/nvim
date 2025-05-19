local pwd = vim.loop.cwd()
return {
    cmd = { "/home/charlie/.local/bin/sith-lsp" },
    single_file_support = true,
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
        ".git",
    },

    root_dir = pwd,

    init_options = {
        settings = {
            -- Settings for the server goes here.
            -- Config example
            ruff = {
                path = "/home/charlie/.local/bin/ruff",
                lint = {
                    enable = true,
                },
            },
        },
    },
}
