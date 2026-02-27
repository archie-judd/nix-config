copilot-delegate() {
	local task="$1"
	if [ -z "$task" ]; then
		echo "Usage: copilot-delegate <task-name> [copilot-args...]" >&2
		return 1
	fi

	local root
	root=$(git rev-parse --show-toplevel 2>/dev/null) || {
		echo "Not in a git repository" >&2
		return 1
	}

	local worktree="$root/.copilot/worktrees/$task"
	local branch="copilot/$task"

	if [ ! -d "$worktree" ]; then
		mkdir -p "$root/.copilot/worktrees"
		git worktree add -b "$branch" "$worktree" || return 1
		mkdir -p "$worktree/.github/agents"
		cp "$HOME/.copilot/prompts/copilot-delegate.md" "$worktree/.github/agents/$task.agent.md"
	fi

	cd "$worktree" || return 1
	gh copilot --agent "$task" "${@:2}"
	printf '\a' > /dev/tty
}
