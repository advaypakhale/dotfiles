return {
    {
        "stevearc/oil.nvim",
        config = function()
            function _G.get_oil_winbar()
                local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
                local dir = require("oil").get_current_dir(bufnr)
                if dir then
                    return vim.fn.fnamemodify(dir, ":~")
                else
                    -- If there is no current directory (e.g. over ssh), just show the buffer name
                    return vim.api.nvim_buf_get_name(0)
                end
            end

            require("oil").setup {
                delete_to_trash = true,
                view_options = {
                    show_hidden = true,
                },
                win_options = {
                    winbar = "%!v:lua.get_oil_winbar()",
                },
                keymaps = {
                    ["<BS>"] = { "actions.parent", mode = "n" },
                    ["<C-c>"] = false,
                },
                float = {
                    padding = 2,
                    max_width = 0,
                    max_height = 0,
                },
            }

            -- Global variable to track Oil window
            _G.oil_win_id = nil

            -- Function to toggle Oil in left vertical split
            function _G.toggle_oil_split()
                if
                    _G.oil_win_id and vim.api.nvim_win_is_valid(_G.oil_win_id)
                then
                    vim.api.nvim_set_current_win(_G.oil_win_id)
                    require("oil.actions").close.callback()
                    vim.api.nvim_win_close(_G.oil_win_id, false)
                    _G.oil_win_id = nil
                else
                    local width = math.floor(vim.o.columns * 0.33)
                    vim.cmd("topleft " .. width .. "vsplit")
                    _G.oil_win_id = vim.api.nvim_get_current_win()
                    require("oil").open()
                end
            end
        end,
        keys = {
            {
                "\\",
                function()
                    _G.toggle_oil_split()
                end,
                desc = "Toggle Oil",
            },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
    },
}
