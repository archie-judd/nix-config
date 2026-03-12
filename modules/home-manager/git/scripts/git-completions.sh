__git_worktree_complete() {
	local worktrees
	worktrees=$(git worktree list --porcelain 2>/dev/null | grep "^worktree " | cut -d' ' -f2 | xargs -n1 basename)
	COMPREPLY=($(compgen -W "$worktrees" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F __git_worktree_complete git-worktree-switch gws
