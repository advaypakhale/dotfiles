# CachyOS ships its defaults here; other distros have no such file.
if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

fish_add_path ~/.local/bin

set -gx EDITOR nvim
set -gx VISUAL nvim

if status is-interactive
    command -q mise; and mise activate fish | source

    alias ccc "claude --dangerously-skip-permissions"
    alias sws "cd ~/workspaces/ros2_ws/"
    alias ros "cd ~/workspaces/ros2-docker/ && ./shell.sh"
    alias opc "ANTIGRAVITY_PROJECT_ID='soc-ge-standard' opencode --dangerously-skip-permissions"
    alias xpp xournalpp
end
