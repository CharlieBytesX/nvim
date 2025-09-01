vim.lsp.config("yamlls", {
    settings = {
        yaml = {
            schemas = {

                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["../path/relative/to/file.yml"] = "/.github/workflows/*",
                ["/path/from/root/of/project"] = "/.github/workflows/*",

                ["https://json.schemastore.org/kustomization.json"] = "**/kustomization.yaml",
                ["https://raw.githubusercontent.com/compose-spec/compose-go/master/schema/compose-spec.json"] = "**/docker-compose.yaml",

                [require("kubernetes").yamlls_schema()] = {
                    "*.yaml",
                    "!**/kustomization.yaml",
                    "!**/docker-compose.yaml",
                    "!**/docker-compose.yaml",
                },
            },
        },
    },
})
