claude-delegate() {
	local task="$1"
	if [ -z "$task" ]; then
		echo "Usage: claude-new <task-name> [claude-args...]" >&2
		return 1
	fi

	claude --worktree "$task" --append-system-prompt-file "$HOME/.claude/prompts/claude-delegate.md" "${@:2}"
}
