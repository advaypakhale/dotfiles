# Advay's Dotfiles

This repository contains many of my configurations for common tools that I use, including [alacritty](https://alacritty.org/), [neovim](https://neovim.io/), and [tmux](https://github.com/tmux/tmux/wiki).

These are personal configurations, meant to only work on my personal machines. They are not configured for general use. If you want to proceed with using them, please be aware that things might break and require some head bashing to work. Nonetheless, there are some barebones neovim setup instructions if you do want to use my configuration.

## Neovim

1. Download [neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md).
2. Clone this directory, and copy the `nvim` subdirectory to `~/.config/nvim`
3. Install dependencies (non-exhaustive, install the rest if you run into errors):
   - **[Go](https://go.dev/doc/install)**
   - **[Node.js & npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)**
   - **[ripgrep](https://github.com/BurntSushi/ripgrep)**
   - **[fd](https://github.com/sharkdp/fd)**
4. Start neovim with `nvim`. You should see most packages and LSPs start to download automatically. If you do run into any errors, just check the log and see what dependencies you are missing, then install them.
5. To ensure that all packages and LSPs have been installed, close neovim and open it again. Then, type in `:Mason` and `:Lazy` and see if you have any errors.

## Acknowledgements

- My neovim configuration is largely ~~stolen~~ adapted from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim).
