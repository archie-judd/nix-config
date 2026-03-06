git-worktree-switch() {
	if [ -z "$1" ]; then
		cd "$(git rev-parse --show-toplevel)" || return 1
		return
	fi
	local target
	target=$(git worktree list --porcelain 2>/dev/null | grep "^worktree " | cut -d' ' -f2 | grep -E "(^|/)$1$")
	if [ -z "$target" ]; then
		echo "No worktree found matching '$1'" >&2
		return 1
	fi
	cd "$target"
}
_git_worktree_switch() {
	local worktrees
	worktrees=$(git worktree list --porcelain 2>/dev/null | grep "^worktree " | cut -d' ' -f2 | xargs -n1 basename)
	COMPREPLY=($(compgen -W "$worktrees" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F _git_worktree_switch git-worktree-switch
