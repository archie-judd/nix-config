git-worktree-delete() {
	local name="${1:?Usage: git-worktree-delete <worktree-name>}"

	local path
	path=$(git worktree list --porcelain | grep "^worktree " | cut -d' ' -f2 | grep -E "(^|/)$name$")

	if [[ -z "$path" ]]; then
		echo "Error: no worktree found matching '${name}'" >&2
		return 1
	fi

	git worktree remove "$path" || {
		echo "Hint: use git-worktree-delete-force to discard uncommitted changes" >&2
		return 1
	}

	echo "Removed worktree: ${path}"
}

_git_worktree_delete_complete() {
	local worktrees
	worktrees=$(git worktree list --porcelain 2>/dev/null | grep "^worktree " | cut -d' ' -f2 | xargs -n1 basename)
	COMPREPLY=($(compgen -W "$worktrees" -- "${COMP_WORDS[COMP_CWORD]}"))
}

complete -F _git_worktree_delete_complete git-worktree-delete
