return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            picker = { enabled = true },
            indent = {
                animate = {
                    enabled = false,
                },
            },
        },
        keys = {
            -- Top Pickers & Explorer
            {
                "<leader>.",
                function()
                    Snacks.picker.smart()
                end,
                desc = "Smart Find Files",
            },
            {
                "<leader><leader>",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Grep",
            },
            -- Search
            {
                "<leader>sb",
                function()
                    Snacks.picker.buffers()
                end,
                desc = "Buffers",
            },
            -- Other
            {
                "<leader>gg",
                function()
                    Snacks.lazygit()
                end,
                desc = "Lazygit",
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    -- Setup some globals for debugging (lazy-loaded)
                    _G.dd = function(...)
                        Snacks.debug.inspect(...)
                    end
                    _G.bt = function()
                        Snacks.debug.backtrace()
                    end
                    vim.print = _G.dd -- Override print to use snacks for `:=` command
                end,
            })
        end,
    },
}
