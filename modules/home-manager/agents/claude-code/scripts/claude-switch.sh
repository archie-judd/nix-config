claude-switch() {
	local root
	root=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || {
		echo "Not in a git repository" >&2
		return 1
	}
	root="${root%/.git}"
	if [ -z "$1" ]; then
		cd "$root"
		return
	fi
	local worktree="$root/.claude/worktrees/$1"
	if [ ! -d "$worktree" ]; then
		echo "No worktree found for '$1'" >&2
		return 1
	fi
	cd "$worktree"
}
