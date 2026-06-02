# Advay's Dotfiles

This repository contains many of my configurations for common tools that I use, including [alacritty](https://alacritty.org/), [neovim](https://neovim.io/), and [tmux](https://github.com/tmux/tmux/wiki).

These are personal configurations, meant to only work on my personal machines. They are not configured for general use. If you want to proceed with using them, please be aware that things might break and require some head bashing to work. Nonetheless, there are some barebones neovim setup instructions if you do want to use my configuration.

## GNU Stow
The repository uses [GNU Stow](https://www.gnu.org/software/stow/) for symlink management.

### Quickstart
Run `stow <tool> -t ~` to set up the necessary symlinks for `tool`.

### Structure
The repository structure is set up to have the tool name as a top-level directory:

```
dotfiles/
└── nvim/
    └── .config/
        └── nvim/
            ├── init.lua
            ├── lua/
            └── ...
```

`stow` by default sets up symlinks relative to the parent directory. So running `stow nvim`, for instance, from within the `dotfiles` directory will create create symlinks in `../.config/nvim/` that point back to `./nvim/.config/nvim/`. If the `dotfiles` repository has been cloned within `$HOME`, then all is well. Otherwise, you have to explicitly specify `$HOME` as the target via `stow nvim -t ~`.

## Neovim

0. Try the (untested) [install script](./scripts/install_nvim.sh).
1. Download [neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md). Installing from pre-built binaries is best.
2. Clone this repository, and run `stow nvim -t ~` from within the repository.
3. Install dependencies (non-exhaustive, install the rest if you run into errors):
   - **[Go](https://go.dev/doc/install)**
   - **[Node.js & npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)**
   - **[ripgrep](https://github.com/BurntSushi/ripgrep)**
   - **[fd](https://github.com/sharkdp/fd)**
4. Start neovim with `nvim`. You should see most packages and LSPs start to download automatically. If you do run into any errors, just check the log and see what dependencies you are missing, then install them.
5. To ensure that all packages and LSPs have been installed, close neovim and open it again. Then, type in `:Mason` and `:Lazy` and see if you have any errors.

## Fonts

The terminal config uses JetBrains Mono Nerd Font. Install it with:

```
./scripts/install_jetbrains_mono.sh
```

This downloads the Nerd Font release into `~/.local/share/fonts` and refreshes the font cache (requires `curl` and `unzip`). Re-running it upgrades in place.

## tmux

Plugins are managed by [tpm](https://github.com/tmux-plugins/tpm), not git submodules. The `plugins/` directory is gitignored.

1. Run `stow tmux -t ~`.
2. Bootstrap tpm:
   ```
   git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
   ```
3. Start tmux and press `prefix + I` to install the remaining plugins (`prefix + U` to update them later).

The Tokyo Night status bar is a minimal theme vendored from [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim) at `tmux/.config/tmux/tokyonight_night.tmux` and `source`d from `tmux.conf` — it is a plain config file, not a plugin, so no install step is needed. To re-sync it with upstream, copy `extras/tmux/tokyonight_night.tmux` from that repo.

## Acknowledgements

- My neovim configuration is largely ~~stolen~~ adapted from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim).
