git-worktree-switch() {
	if [ -z "$1" ]; then
		cd "$(git rev-parse --show-toplevel)" || return 1
		return
	fi
	local matches
	matches=$(git worktree list --porcelain 2>/dev/null | grep "^worktree " | cut -d' ' -f2 | grep -E "(^|/)$1$")
	if [ -z "$matches" ]; then
		echo "No worktree found matching '$1'" >&2
		return 1
	fi
	if [ "$(echo "$matches" | wc -l)" -gt 1 ]; then
		echo "Ambiguous worktree name '$1'. Matches:" >&2
		echo "$matches" >&2
		return 1
	fi
	cd "$matches"
}
