vim.lsp.config("yamlls", {
    settings = {
        yaml = {
            schemas = {

                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["../path/relative/to/file.yml"] = "/.github/workflows/*",
                ["/path/from/root/of/project"] = "/.github/workflows/*",

                ["https://json.schemastore.org/kustomization.json"] = "**/kustomization.yaml", -- This effectively assigns no schema to kustomization.yaml

                [require("kubernetes").yamlls_schema()] = { "*.yaml", "!**/kustomization.yaml" },
            },
        },
    },
})
