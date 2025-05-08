return{
    "mason-org/mason.nvim",
    dependencies = {
        "mason-org/mason-lspconfig.nvim",
    },

    config = function()
       local mason = require("mason")

        local mason_lspconfig = require("mason-lspconfig")


        mason.setup({

        })

        mason_lspconfig.setup({
            ensure_installed = {
                ensure_installed = { "lua_ls", "pyright" },
            }
        })

    end,
}
