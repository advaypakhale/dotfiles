require("snacks").setup {
    picker = { enabled = true },
    indent = {
        animate = {
            enabled = false,
        },
    },
}

-- Pickers & explorer
vim.keymap.set("n", "<leader>.", function()
    Snacks.picker.smart()
end, { desc = "Smart Find Files" })
vim.keymap.set("n", "<leader><leader>", function()
    Snacks.picker.grep()
end, { desc = "Grep" })
vim.keymap.set("n", "<leader>sb", function()
    Snacks.picker.buffers()
end, { desc = "Buffers" })
vim.keymap.set({ "n", "x" }, "<leader>sw", function()
    Snacks.picker.grep_word()
end, { desc = "Search current Word" })
vim.keymap.set("n", "<leader>sc", function()
    Snacks.picker.commands()
end, { desc = "Search Commands" })
vim.keymap.set("n", "<leader>gg", function()
    Snacks.lazygit()
end, { desc = "Lazygit" })

-- Globals for debugging
_G.dd = function(...)
    Snacks.debug.inspect(...)
end
_G.bt = function()
    Snacks.debug.backtrace()
end
vim.print = _G.dd -- Override print to use snacks for `:=` command
