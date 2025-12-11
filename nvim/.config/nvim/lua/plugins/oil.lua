return {
    {
        "stevearc/oil.nvim",
        config = function()
            _G.oil_win_id = nil
            _G.oil_source_win = nil

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
                    _G.oil_source_win = vim.api.nvim_get_current_win()

                    local width = math.floor(vim.o.columns * 0.33)
                    vim.cmd("topleft " .. width .. "vsplit")
                    _G.oil_win_id = vim.api.nvim_get_current_win()
                    require("oil").open()
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
                    ["<CR>"] = {
                        callback = function()
                            local oil = require "oil"
                            local entry = oil.get_cursor_entry()

                            if entry and entry.type == "file" then
                                local dir = oil.get_current_dir()
                                local filepath = dir .. entry.name

                                local target_win = _G.oil_source_win
                                if
                                    not target_win
                                    or not vim.api.nvim_win_is_valid(target_win)
                                then
                                    local wins = vim.api.nvim_list_wins()
                                    for _, win in ipairs(wins) do
                                        local buf =
                                            vim.api.nvim_win_get_buf(win)
                                        if
                                            vim.bo[buf].filetype ~= "oil"
                                            and win ~= _G.oil_win_id
                                        then
                                            target_win = win
                                        end
                                    end
                                end

                                if
                                    target_win
                                    and vim.api.nvim_win_is_valid(target_win)
                                then
                                    vim.api.nvim_set_current_win(target_win)
                                    vim.cmd(
                                        "edit " .. vim.fn.fnameescape(filepath)
                                    )
                                else
                                    -- Fallback: use default behavior
                                    oil.select()
                                end
                            else
                                -- For directories, use default behavior
                                oil.select()
                            end
                        end,
                        desc = "Open in target window",
                        mode = "n",
                    },
                },
            }
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
