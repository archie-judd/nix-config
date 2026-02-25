claude-delete() {
	local root
	root=$(git rev-parse --show-toplevel 2>/dev/null) || {
		echo "Not in a git repository" >&2
		return 1
	}
	local task="$1"
	if [ -z "$task" ]; then
		echo "Usage: claude-delete <task-name>" >&2
		return 1
	fi
	local worktree="$root/.claude/worktrees/$task"
	local branch="agent/$task"

	if [ -d "$worktree" ]; then
		git worktree remove "$worktree" --force
	fi
	if git rev-parse --verify "$branch" >/dev/null 2>&1; then
		git branch -D "$branch"
	fi
	echo "Removed worktree and branch for '$task'"
}
