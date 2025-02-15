return {
    {
        "folke/tokyonight.nvim",
        opts = {},
        init = function()
            vim.cmd.hi "Comment gui=none"
        end,
    },
}
-- vim: ts=2 sts=2 sw=2 et
