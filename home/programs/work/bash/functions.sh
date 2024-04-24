#!/bin/bash

function _git_branch_completion {
	local branches_str
	local branches_arr
	local num_branches
	branches_str=$(git branch | awk '{print $NF}')
	branches_arr=($branches_str)
	num_branches=${#branches_arr[@]}
	if [[ $COMP_CWORD -le $num_branches ]]; then
		COMPREPLY=($(compgen -W "$branches_str" -- "${COMP_WORDS[COMP_CWORD]}"))
	else
		COMPREPLY=()
	fi
}

function git_branch_delete() {
	for branch in "$@"; do
		git branch -D $branch
		git push --delete origin $branch
	done
}

complete -F _git_branch_completion git_branch_delete

function _poetry_active() {
	source $(poetry env list --full-path | cut -d' ' -f1)/bin/activate
}
function poetry_activate() {
	if deactivate; then
		echo current python environment deactivated
		sleep 2
	else
		echo not currently in a python environment
	fi
	if poetry_activate; then
		echo poetry activated: $(poetry env list --full-path | cut -d' ' -f1)/bin/activate
	else
		echo cannot find poetry environment at: $(poetry env list --full-path | cut -d' ' -f1)/bin/activate
	fi
}

function tmux_hsplit() {
	local bottom_proportion=${1:-50}
	echo $bottom_proportion
	local bottom_height="$(($bottom_proportion * $LINES / 100))"
	tmux split-window -v -l $bottom_height -c $PWD \; select-pane -U
}
