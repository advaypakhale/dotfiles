return {
    {
        "zapling/mason-conform.nvim",
        event = "VeryLazy",
        dependencies = { "conform.nvim" },
        config = function()
            require("mason-conform").setup {
                -- List of formatters to ignore during install
                ignore_install = {},
            }
        end,
    },
}
