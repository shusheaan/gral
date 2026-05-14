#!/usr/bin/env zsh
set -euo pipefail

# Split the active pane horizontally so the left child is 25% of the
# whole tmux window, not 25% of the currently focused pane.
window_width=$(tmux display-message -p '#{window_width}')
pane_width=$(tmux display-message -p '#{pane_width}')
pane_path=$(tmux display-message -p '#{pane_current_path}')

target_left=$(( window_width / 4 ))
min_right=12

if (( pane_width <= target_left + min_right )); then
    tmux display-message "Not enough width: pane=${pane_width}, target-left=${target_left}, min-right=${min_right}"
    exit 0
fi

new_right=$(( pane_width - target_left ))

tmux split-window -h -l "${new_right}" -c "${pane_path}"
tmux select-pane -L
