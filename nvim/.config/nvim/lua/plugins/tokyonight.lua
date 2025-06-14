return {
    {
        "folke/tokyonight.nvim",
        priority = 10000,
        config = function()
            require("tokyonight").setup {
                -- transparent = true,
                -- styles = {
                --     sidebars = "transparent",
                --     floats = "transparent",
                -- },
            }

            -- Load the colorscheme here.
            -- Like many other themes, this one has different styles, and you could load
            -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
            vim.cmd.colorscheme "tokyonight-night"
        end,
    },
}
-- vim: ts=2 sts=2 sw=2 et
