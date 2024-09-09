#!/bin/bash

function git_branch_delete() {
	for branch in "$@"; do
		git branch -d "$branch"
		git push -d origin "$branch"
	done
}

__git_complete git_branch_delete _git_branch

function git_tag_delete() {
	for tag in "$@"; do
		git tag -d "$tag"
		git push -d origin "$tag"
	done
}

__git_complete git_tag_delete _git_tag

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
