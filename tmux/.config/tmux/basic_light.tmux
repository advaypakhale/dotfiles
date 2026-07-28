#!/usr/bin/env bash

# basic_light status bar, matching the Alacritty/Neovim themes of the same name.
# Sourced from tmux.conf, not a tpm plugin.
#
# Contrast rule: text is either dark-on-light or white-on-a-dark-fill, never
# mid-tone on mid-tone (washes out in sunlight).
#
# Palette: fill=#0000c0 (blue)  on_fill=#ffffff  status_bg=#e6e6e6
#          seg_bg=#c6c6c6  ink=#000000  muted=#565656  prefix=#b00000 (red)

set -g mode-style "fg=#ffffff,bg=#0000c0"

set -g message-style "fg=#ffffff,bg=#0000c0"
set -g message-command-style "fg=#ffffff,bg=#0000c0"

set -g pane-border-style "fg=#c6c6c6"
set -g pane-active-border-style "fg=#0000c0"

set -g status "on"
set -g status-justify "left"

set -g status-style "fg=#000000,bg=#e6e6e6"

set -g status-left-length "100"
set -g status-right-length "100"

set -g status-left-style NONE
set -g status-right-style NONE

set -g status-left "#[fg=#ffffff,bg=#0000c0,bold] #S #[fg=#0000c0,bg=#e6e6e6,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=#e6e6e6,bg=#e6e6e6,nobold,nounderscore,noitalics]#[fg=#000000,bg=#e6e6e6] #{prefix_highlight} #[fg=#c6c6c6,bg=#e6e6e6,nobold,nounderscore,noitalics]#[fg=#000000,bg=#c6c6c6] %Y-%m-%d  %I:%M %p #[fg=#0000c0,bg=#c6c6c6,nobold,nounderscore,noitalics]#[fg=#ffffff,bg=#0000c0,bold] #h "
if-shell '[ "$(tmux show-option -gqv "clock-mode-style")" == "24" ]' {
  set -g status-right "#[fg=#e6e6e6,bg=#e6e6e6,nobold,nounderscore,noitalics]#[fg=#000000,bg=#e6e6e6] #{prefix_highlight} #[fg=#c6c6c6,bg=#e6e6e6,nobold,nounderscore,noitalics]#[fg=#000000,bg=#c6c6c6] %Y-%m-%d  %H:%M #[fg=#0000c0,bg=#c6c6c6,nobold,nounderscore,noitalics]#[fg=#ffffff,bg=#0000c0,bold] #h "
}

setw -g window-status-activity-style "underscore,fg=#565656,bg=#e6e6e6"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=#565656,bg=#e6e6e6"
setw -g window-status-format "#[fg=#e6e6e6,bg=#e6e6e6,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#e6e6e6,bg=#e6e6e6,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=#0000c0,bg=#0000c0,nobold,nounderscore,noitalics]#[fg=#ffffff,bg=#0000c0,bold] #I  #W #F #[fg=#0000c0,bg=#e6e6e6,nobold,nounderscore,noitalics]"

# tmux-plugins/tmux-prefix-highlight support
set -g @prefix_highlight_output_prefix "#[fg=#b00000]#[bg=#e6e6e6]#[fg=#e6e6e6]#[bg=#b00000]"
set -g @prefix_highlight_output_suffix ""
