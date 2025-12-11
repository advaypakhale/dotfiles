return {
    {
        "advaypakhale/remote.nvim",
        config = function()
            require("remote").setup()

            vim.keymap.set(
                "n",
                "<leader>rs",
                "<cmd>RemoteSetup<CR>",
                { desc = "Setup remote" }
            )

            vim.keymap.set(
                "n",
                "<leader>ry",
                "<cmd>RemoteSync<CR>",
                { desc = "Sync remote" }
            )

            vim.keymap.set(
                "n",
                "<leader>rc",
                "<cmd>RemoteCleanup<CR>",
                { desc = "Cleanup remote" }
            )
        end,
    },
}
