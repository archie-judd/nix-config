bottom_proportion=${1:-50}
bottom_height="$(($(tput lines) * bottom_proportion / 100))"
tmux split-window -v -l $bottom_height -c "$PWD" \; select-pane -U
