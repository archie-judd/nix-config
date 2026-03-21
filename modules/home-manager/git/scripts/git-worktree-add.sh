git-worktree-add() {
	if [ -z "$1" ]; then
		echo "Usage: git-worktree-add <branch> [extra args...]" >&2
		return 1
	fi
	local branch="$1"
	shift
	local repo_root
	repo_root="$(git rev-parse --git-common-dir 2>/dev/null)/.." || return 1
	repo_root="$(cd "$repo_root" && pwd)"
	local worktree_name="${branch//\//-}"
	local worktree_path="$repo_root/.worktrees/$worktree_name"
	if [ -d "$worktree_path" ]; then
		echo "Worktree '$worktree_name' already exists at $worktree_path" >&2
		return 1
	fi
	if git rev-parse --verify "$branch" >/dev/null 2>&1; then
		git worktree add "$@" "$worktree_path" "$branch" || return 1
	else
		local remote_matches
		remote_matches=$(git branch -r --format='%(refname:short)' | grep -E "/$branch$")
		local match_count
		match_count=$(echo "$remote_matches" | grep -c . 2>/dev/null || true)
		if [ "$match_count" -eq 1 ]; then
			git worktree add -b "$branch" "$@" "$worktree_path" "$remote_matches" || return 1
		elif [ "$match_count" -gt 1 ]; then
			echo "Ambiguous: branch '$branch' exists on multiple remotes:" >&2
			echo "$remote_matches" >&2
			return 1
		else
			git worktree add -b "$branch" "$@" "$worktree_path" HEAD || return 1
		fi
	fi
	cd "$worktree_path"
}
