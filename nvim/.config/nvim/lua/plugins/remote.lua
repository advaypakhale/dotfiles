require("remote").setup()

vim.keymap.set("n", "<leader>rr", "<cmd>Remote install<CR>", { desc = "Install Neovim on remote" })

vim.keymap.set("n", "<leader>rR", "<cmd>Remote! install<CR>", { desc = "Reinstall Neovim on remote" })

vim.keymap.set("n", "<leader>rc", "<cmd>Remote cleanup<CR>", { desc = "Remove remote install" })
