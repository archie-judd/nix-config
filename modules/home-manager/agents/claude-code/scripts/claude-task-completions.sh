_claude_task_completions() {
	if [ "${COMP_CWORD}" -ne 1 ]; then
		return
	fi
	local root
	root=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || return
	root="${root%/.git}"
	local worktree_dir="$root/.claude/worktrees"
	if [ -d "$worktree_dir" ]; then
		COMPREPLY=($(cd "$worktree_dir" && compgen -d -- "${COMP_WORDS[COMP_CWORD]}"))
	fi
}
