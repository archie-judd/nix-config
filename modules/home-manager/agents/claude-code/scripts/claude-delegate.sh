claude-delegate() {
	local task="$1"
	if [ -z "$task" ]; then
		echo "Usage: claude-delegate <task-name> [claude-args...]" >&2
		return 1
	fi

	claude --worktree "$task" --append-system-prompt-file "$HOME/.claude/prompts/delegate.md" --dangerously-skip-permissions "${@:2}"
}
