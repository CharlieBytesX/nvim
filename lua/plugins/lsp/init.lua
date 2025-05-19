local M = {}
M.plugins = {
    require("plugins.lsp.mason"),
}

function M.setup()
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = require("plugins.lsp.lsp_on_attach").setup,
    })
end

require("plugins.lsp.diagnostics")
return M
