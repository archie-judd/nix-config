copilot-resume() {
	local root
	root=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || {
		echo "Not in a git repository" >&2
		return 1
	}
	root="${root%/.git}"
	local task="$1"
	if [ -z "$task" ]; then
		echo "Usage: copilot-resume <task-name>" >&2
		return 1
	fi
	shift
	local worktree="$root/.copilot/worktrees/$task"
	if [ ! -d "$worktree" ]; then
		echo "No worktree found for '$task'" >&2
		return 1
	fi
	cd "$worktree" || return 1
	copilot --agent "delegate" --yolo --continue "$@"
}
