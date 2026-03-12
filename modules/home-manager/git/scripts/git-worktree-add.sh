git-worktree-add() {
	local branch="${1:?Usage: git-worktree-add <branch-name> [base-branch]}"
	local base="${2:-HEAD}"
	local root
	root=$(git rev-parse --show-toplevel 2>/dev/null) || {
		echo "Error: not inside a git repository" >&2
		return 1
	}

	local worktree_dir="${root}/.worktrees/${branch}"

	if [[ -d "$worktree_dir" ]]; then
		echo "Error: worktree already exists at ${worktree_dir}" >&2
		return 1
	fi

	mkdir -p "${root}/.worktrees"

	if git show-ref --verify --quiet "refs/heads/${branch}"; then
		# Branch already exists — check it out
		git worktree add "${worktree_dir}" "${branch}"
	else
		# Create new branch from base
		git worktree add -b "${branch}" "${worktree_dir}" "${base}"
	fi

	echo "Worktree ready: ${worktree_dir}"
}
