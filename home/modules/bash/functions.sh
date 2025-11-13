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

function git_review_pr() {
	if [ "$#" -ne 2 ]; then
		echo "Usage: git_review_pr <base-branch> <feature-branch>"
		return 1
	fi

	# Check for uncommitted changes (staged or unstaged)
	# Allow untracked files
	if ! git diff --quiet || ! git diff --cached --quiet; then
		echo "Error: You have uncommitted changes. Please commit or stash them first."
		git status --short
		return 1
	fi

	local BASE_BRANCH=$1
	local FEATURE_BRANCH=$2
	local PREVIOUS_BRANCH

	# Capture the current branch
	PREVIOUS_BRANCH=$(git rev-parse --abbrev-ref HEAD)

	git fetch origin "$BASE_BRANCH" "$FEATURE_BRANCH" || return 1
	git checkout "$BASE_BRANCH" || return 1
	git pull origin "$BASE_BRANCH" || return 1
	git checkout "$FEATURE_BRANCH" || return 1
	git pull origin "$FEATURE_BRANCH" || return 1
	git reset --soft "$(git merge-base origin/"$BASE_BRANCH" HEAD)"

	git config review.previousbranch "$PREVIOUS_BRANCH"

	echo "PR review setup complete."
	echo "To cleanup: git_review_pr_cleanup"
}

__git_complete git_review_pr _git_switch

git_review_pr_cleanup() {
	local PREVIOUS_BRANCH
	PREVIOUS_BRANCH=$(git config review.previousbranch)

	if [ -z "$PREVIOUS_BRANCH" ]; then
		echo "Error: No previous branch found. Please specify: git_review_pr_cleanup <branch>"
		return 1
	fi

	git reset --hard HEAD
	git checkout "$PREVIOUS_BRANCH"
	git config --unset review.previousbranch

	echo "Cleanup complete. Returned to $PREVIOUS_BRANCH"
}

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
