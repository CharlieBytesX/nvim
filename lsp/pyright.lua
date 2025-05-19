return {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = "python",
    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
        ".git",
    },

    settings = {
        python = {
            diasableOrganizeImports = true,
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                autoImportCompletions = true,
            },
        },
    },
}
