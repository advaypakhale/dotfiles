# Advay's Dotfiles

[![ci](https://github.com/advaypakhale/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/advaypakhale/dotfiles/actions/workflows/ci.yml)

This repository contains many of my configurations for common tools that I use, including [alacritty](https://alacritty.org/), [neovim](https://neovim.io/), and [tmux](https://github.com/tmux/tmux/wiki).

These are personal configurations, meant to only work on my personal machines. They are not configured for general use. If you want to proceed with using them, please be aware that things might break and require some head bashing to work. Nonetheless, there are some barebones neovim setup instructions if you do want to use my configuration.

## Quickstart

```
sudo apt install stow
curl https://mise.run | sh
mise run bootstrap    # server profile: bash, bin, claude, mise, nvim, tmux
mise run desktop      # adds alacritty, xournalpp, fonts
```

Both tasks are safe to rerun; run `bootstrap` again after pulling changes.
It symlinks the config packages with stow, then installs the tools pinned in
`mise/.config/mise/config.toml`. An unmanaged `~/.bashrc` is moved to
`~/.bashrc.pre-dotfiles`.

Machine-local shell config goes in `~/.config/shell/local.sh` (untracked).

## GNU Stow
The repository uses [GNU Stow](https://www.gnu.org/software/stow/) for symlink
management; the `stow` task in `mise.toml` runs it. To manage a single package
manually: `stow --no-folding <tool> -t ~`.

`--no-folding` is not optional. Without it, stow symlinks a whole directory
whenever the target does not exist yet, so `~/.local/bin` and `~/.claude` become
this repository and anything an installer or app writes there lands in git.

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

Installed by the bootstrap (nightly channel, via mise) along with its
dependencies (node for Mason packages, ripgrep, fd, tree-sitter CLI).

1. Start neovim with `nvim`. Packages and LSPs download automatically on first
   start.
2. Close and reopen, then check `:Mason` and `:checkhealth vim.pack` for
   errors.

## Fonts

The terminal config uses JetBrains Mono Nerd Font. Install it with:

```
mise run fonts
```

This downloads the Nerd Font release into `~/.local/share/fonts` and refreshes the font cache (requires `curl` and `unzip`). Re-running it upgrades in place.

## TrackPoint (ThinkPad)

Not a stow package; files install to system paths via the script:

```
mise run trackpoint
```

A systemd service and sleep hook apply the hardware knobs (`sensitivity`,
`speed`, `inertia`) at boot and on resume; `gsettings` sets the pointer accel.
Edit values in `trackpoint/trackpoint-tune.sh` and `ACCEL` in the install
script, then re-run it.

## tmux

Plugins are managed by [tpm](https://github.com/tmux-plugins/tpm). The `plugins/` directory is gitignored.

tpm is cloned by the bootstrap. Start tmux and press `prefix + I` to install
the remaining plugins (`prefix + U` to update them later).

The status bar is a minimal theme, sourced by `tmux.conf` per the shared light/dark state (see [Theme switching](#theme-switching-lightdark)). `tokyonight_night.tmux` is copied from [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim) (`extras/tmux/`); `basic_light.tmux` matches the Alacritty and Neovim themes of the same name. Both are plain config files, not plugins, so no install step is needed.

## Theme switching (light/dark)

The `theme` command flips Alacritty, Neovim, and tmux between dark and light
together, via a shared state file at `~/.config/theme/mode`.

- **Dark** is TokyoNight Night.
- **Light** is `basic_light`: black on white with dark saturated primaries, for
  legibility in direct sunlight.

Each theme has three pieces — an Alacritty theme in
`alacritty/.config/alacritty/themes/`, a tmux status bar in
`tmux/.config/tmux/`, and (for light) a Neovim colorscheme in
`nvim/.config/nvim/colors/`.

```
theme          # toggle dark <-> light
theme light    # force light
theme dark     # force dark
theme status   # print current mode
```

Setup (own stow package): `stow --no-folding bin -t ~`, then `theme dark` once to create
`~/.config/theme/`. Alacritty repaints live via `live_config_reload`; Neovim
watches the state file; tmux is re-sourced and redrawn by the script (it won't
follow on its own). All switch without a restart. To swap the light half, edit
two places: the `[light]` entries in `bin/.local/bin/theme` and `schemes.light`
in `nvim/.config/nvim/lua/theme.lua`.

Claude Code follows along on its own — see [Claude Code](#claude-code).

## Claude Code

`stow --no-folding claude -t ~` symlinks `~/.claude/settings.json` (shared, non-secret
settings only — machine-local `settings.local.json` is not tracked). Its `theme`
is `auto`, which detects the terminal background, so it tracks the switcher
without being wired into it.

Skills live in [agent-skills](https://github.com/advaypakhale/agent-skills), a
separate repository so they can be cloned without the rest of this one.
The `agent-skills` bootstrap task clones it and symlinks it as
`~/.claude/skills`.

## Xournal++

Configuration for [Xournal++](https://xournalpp.github.io/). Run `stow --no-folding xournalpp -t ~`.

## Acknowledgements

- My neovim configuration is largely ~~stolen~~ adapted from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim).
