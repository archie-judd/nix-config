claude-new() {
	local task="$1"
	if [ -z "$task" ]; then
		echo "Usage: claude-new <task-name> [claude args...]" >&2
		return 1
	fi
	shift
	@claude@ --worktree "$task" "$@"
}
