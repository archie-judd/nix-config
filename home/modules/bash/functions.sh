#!/bin/bash

function git_branch_delete() {
	for branch in "$@"; do
		git branch -d "$branch"
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

# This function will convert a JSON file to a single line using jq.
function onelineify_json() {
	local json_file="$1"
	jq -c . "$json_file" >"$json_file.tmp" && mv "$json_file.tmp" "$json_file"
}

function onelineify_json_git_diff() {
	git diff --name-only | grep '\.json$' | while read -r json_file; do
		onelineify_json "$json_file"
	done
}

function check_py_init_files() {
	local root_dir="$1"
	local missing_init_dirs=()

	# Find all subdirectories excluding __pycache__ and other cache dirs
	while IFS= read -r subdir; do
		# Check if __init__.py exists in the subdirectory
		if [[ ! -f "$subdir/__init__.py" ]]; then
			missing_init_dirs+=("$subdir")
		fi
	done < <(find "$root_dir" -type d \( ! -name "__pycache__" ! -name "*.cache" \))

	# Print subdirectories missing __init__.py
	if [[ ${#missing_init_dirs[@]} -gt 0 ]]; then
		echo "Subdirectories missing __init__.py:"
		for dir in "${missing_init_dirs[@]}"; do
			echo "$dir"
		done
	else
		echo "All subdirectories have __init__.py files."
	fi
}
