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
    settings = {
        -- Settings for the server goes here.
        -- Config example
        ruff = {
            lint = {
                enable = true,
            },
        },
    },
}
