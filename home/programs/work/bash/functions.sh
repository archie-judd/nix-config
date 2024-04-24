#!/bin/bash

function _git_branch_completion {
	local branches
	branches=$(git branch 2>/dev/null | awk '{print $NF}')
	branches_local=$(git branches 2>/dev/null)
	echo ${#branches_local[@]}
	if [[ $COMP_CWORD -le 1 ]]; then
		COMPREPLY=($(compgen -W "$branches" -- "${COMP_WORDS[COMP_CWORD]}"))
	else
		COMPREPLY=()
	fi
}

function git_delete_branch() {
	git branch -D $1
	git push --delete origin $1
}

complete -F _git_branch_completion git_delete_branch

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
