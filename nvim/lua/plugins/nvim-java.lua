return {
    {
        "nvim-java/nvim-java",
        lazy = false,
        dependencies = {
            "nvim-java/lua-async-await",
            "nvim-java/nvim-java-core",
            "nvim-java/nvim-java-test",
            "nvim-java/nvim-java-dap",
            "MunifTanjim/nui.nvim",
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap",
            {
                "mason-org/mason.nvim",
                opts = {
                    registries = {
                        "github:nvim-java/mason-registry",
                        "github:mason-org/mason-registry",
                    },
                },
            },
        },
        config = function()
            require("java").setup {}
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            require("lspconfig").jdtls.setup {
                capabilities = capabilities,
                filetypes = { "java" },
            }
        end,
    },
}
