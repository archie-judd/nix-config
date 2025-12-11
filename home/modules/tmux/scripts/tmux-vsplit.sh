right_proportion=${1:-50}
right_width="$(($(tput cols) * right_proportion / 100))"
tmux split-window -h -l $right_width -c "$PWD" \; select-pane -U
