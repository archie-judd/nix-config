#!/bin/bash

function _git_branch_completion {
	local branches_str
	local branches_arr
	local num_branches
	branches_str=$(git branch | awk '{print $NF}')
	branches_arr=("$branches_str")
	num_branches=${#branches_arr[@]}
	if [[ $COMP_CWORD -le $num_branches ]]; then
		# the following with mapfile instead
		COMPREPLY=($(compgen -W "$branches_str" -- "${COMP_WORDS[COMP_CWORD]}"))
	else
		COMPREPLY=()
	fi
}

function git_branch_delete() {
	for branch in "$@"; do
		git branch -D "$branch"
		git push --delete origin "$branch"
	done
}

complete -F _git_branch_completion git_branch_delete

function tmux_hsplit() {
	local bottom_proportion
	local bottom_height
	bottom_proportion=${1:-50}
	bottom_height="$((bottom_proportion * LINES / 100))"
	tmux split-window -v -l $bottom_height -c "$PWD" \; select-pane -U
}

function tmux_vsplit() {
	local right_proportion
	local right_width
	right_proportion=${1:-50}
	right_width="$((right_proportion * COLUMNS / 100))"
	tmux split-window -h -l $right_width -c "$PWD" \; select-pane -U
}

# Run neovim with a custom runtime path
function nvim_rtp() {
	# remove trailing slash
	local runtimepath="${1%/}"
	nvim --cmd "set runtimepath^=$runtimepath" -u "$runtimepath/init.lua"
}
