#!/usr/bin/env bash
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# title      Tokyo Night (Duller Green Half-Diamond)                  +
# version    1.0.0                                                    +
# repository https://github.com/logico-dev/tokyo-night-tmux           +
# author     Lógico                                                   +
# email      hi@logico.com.ar                                         +
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_PATH="$CURRENT_DIR/src"

tmux set -g status-left-length 80
tmux set -g status-right-length 150

RESET="#[fg=#a9b1d6,bg=#232A38,nobold,noitalics,nounderscore,nodim]" # Darkened bg

# Change highlight colors to a duller green (#7eca9c)
tmux set -g mode-style "fg=#7eca9c,bg=#222836"
tmux set -g message-style "bg=#688cb5,fg=#232A38"
tmux set -g message-command-style "fg=#7eca9c,bg=#3a4b5d"

tmux set -g pane-border-style "fg=#222836"
tmux set -g pane-active-border-style "fg=#7eca9c"
tmux set -g pane-border-status off

tmux set -g status-style bg="default"

TMUX_VARS="$(tmux show -g)"

default_window_id_style="digital"
default_pane_id_style="hsquare"
default_zoom_id_style="dsquare"

window_id_style="$(echo "$TMUX_VARS" | grep '@tokyo-night-tmux_window_id_style' | cut -d" " -f2)"
pane_id_style="$(echo "$TMUX_VARS" | grep '@tokyo-night-tmux_pane_id_style' | cut -d" " -f2)"
zoom_id_style="$(echo "$TMUX_VARS" | grep '@tokyo-night-tmux_zoom_id_style' | cut -d" " -f2)"
window_id_style="${window_id_style:-$default_window_id_style}"
pane_id_style="${pane_id_style:-$default_pane_id_style}"
zoom_id_style="${zoom_id_style:-$default_zoom_id_style}"

window_number="#($SCRIPTS_PATH/custom-number.sh #I $window_id_style)"
custom_pane="#($SCRIPTS_PATH/custom-number.sh #P $pane_id_style)"
cpu_status="#(bash $SCRIPTS_PATH/cpu.sh)"
memory_status="#(bash $SCRIPTS_PATH/memory.sh)"

# Half-diamond style glyphs (requires Powerline/Nerd Font)
LEFT_HALF_DIAMOND="#[bg=default,none,dim,fg=#011A1A]"
RIGHT_HALF_DIAMOND="#[bg=default,none,dim,fg=#011A1A]"

#+--- Bars LEFT ---+
tmux set -g status-left "$LEFT_HALF_DIAMOND#[fg=##4B4F53,bg=#0A0A0A] #{?client_prefix,󰠠 ,#[dim]󰤂 }#[fg=##4B4F53,bg=#0A0A0A,nodim]#S $RESET"

#+--- Windows ---+
# Focused window
tmux set -g window-status-current-format "#[fg=#225555,bg=#0A0A0A] #[fg=#225555]$window_number #[nodim]#W#[nobold,dim]#{?window_zoomed_flag, $zoom_number, $custom_pane} #{?window_last_flag,,}$RIGHT_HALF_DIAMOND"
# Unfocused window
tmux set -g window-status-format "#[fg=#225555,bg=default,none,dim] $window_number #W#[nobold,dim]#{?window_zoomed_flag, $zoom_number, $custom_pane}#[fg=#225555] #{?window_last_flag,󰁯 ,} "

#+--- Bars RIGHT ---+
tmux set -g status-interval 5
tmux set -g status-right "#[fg=##4B4F53, bg=default,none,dim] 󰍛 $cpu_status #[fg=#225555,bg=default,none,dim] 󰍜 $memory_status"
