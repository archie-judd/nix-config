#!/bin/bash

function git_branch_delete() {
	for branch in "$@"; do
		git branch -D "$branch"
		git push -d origin "$branch"
	done
}

__git_complete git_branch_delete _git_switch

function git_tag_delete() {
	for tag in "$@"; do
		git tag -d "$tag"
		git push -d origin "$tag"
	done
}

__git_complete git_tag_delete _git_tag

git_review_pr() {
	if [ "$#" -ne 2 ]; then
		echo "Usage: git_review_pr <base-branch> <feature-branch>"
		return 1
	fi
	local BASE_BRANCH=$1
	local FEATURE_BRANCH=$2
	git fetch origin "$BASE_BRANCH"
	git checkout "$BASE_BRANCH"
	git pull origin "$BASE_BRANCH"
	git fetch origin "$FEATURE_BRANCH"
	git checkout "$FEATURE_BRANCH"
	git pull origin "$FEATURE_BRANCH"
	git reset --soft "$(git merge-base origin/"$BASE_BRANCH" HEAD)"
	echo "PR review setup complete. You are now on the feature branch with a soft reset to the merge-base."
}

__git_complete git_review_pr _git_switch

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
	shift
	nvim --cmd "set runtimepath^=$runtimepath" -u "$runtimepath/init.lua" "$@"
}
