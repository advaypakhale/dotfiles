-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do
return {
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            signs_staged = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
            },
            on_attach = function(bufnr)
                local gitsigns = require "gitsigns"

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal { "]c", bang = true }
                    else
                        gitsigns.nav_hunk "next"
                    end
                end, { desc = "Jump to next git [c]hange" })

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal { "[c", bang = true }
                    else
                        gitsigns.nav_hunk "prev"
                    end
                end, { desc = "Jump to previous git [c]hange" })

                -- Actions
                -- visual mode
                map("v", "<leader>ghs", function()
                    gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
                end, { desc = "[g]it [h]unk [s]tage" })
                map("v", "<leader>ghr", function()
                    gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
                end, { desc = "[g]it [h]unk [r]eset" })
                -- normal mode
                map(
                    "n",
                    "<leader>ghs",
                    gitsigns.stage_hunk,
                    { desc = "git [s]tage hunk" }
                )
                map(
                    "n",
                    "<leader>ghr",
                    gitsigns.reset_hunk,
                    { desc = "git [r]eset hunk" }
                )
                map(
                    "n",
                    "<leader>gS",
                    gitsigns.stage_buffer,
                    { desc = "git [S]tage buffer" }
                )
                map(
                    "n",
                    "<leader>ghu",
                    gitsigns.stage_hunk,
                    { desc = "git [u]ndo stage hunk" }
                )
                map(
                    "n",
                    "<leader>gR",
                    gitsigns.reset_buffer,
                    { desc = "git [R]eset buffer" }
                )
                map(
                    "n",
                    "<leader>ghp",
                    gitsigns.preview_hunk,
                    { desc = "git [p]review hunk" }
                )
                map(
                    "n",
                    "<leader>gb",
                    gitsigns.blame_line,
                    { desc = "git [b]lame line" }
                )
                map(
                    "n",
                    "<leader>gd",
                    gitsigns.diffthis,
                    { desc = "git [d]iff against index" }
                )
                map("n", "<leader>gD", function()
                    gitsigns.diffthis "@"
                end, { desc = "git [D]iff against last commit" })
                -- Toggles
                map(
                    "n",
                    "<leader>tb",
                    gitsigns.toggle_current_line_blame,
                    { desc = "[T]oggle git show [b]lame line" }
                )
                map(
                    "n",
                    "<leader>tD",
                    gitsigns.preview_hunk_inline,
                    { desc = "[T]oggle git show [D]eleted" }
                )
            end,
        },
    },
}
-- vim: ts=2 sts=2 sw=2 et
