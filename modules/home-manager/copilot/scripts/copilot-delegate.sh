copilot-delegate() {
	local task="" ref=""
	while [[ $# -gt 0 ]]; do
		case "$1" in
		--ref)
			ref="$2"
			shift 2
			;;
		*) if [ -z "$task" ]; then
			task="$1"
			shift
		else break; fi ;;
		esac
	done
	[ -z "$task" ] && {
		echo "Usage: copilot-delegate [--ref <ref>] <task> [args...]" >&2
		return 1
	}

	local root
	root=$(git rev-parse --show-toplevel 2>/dev/null) || {
		echo "Not in a git repository" >&2
		return 1
	}
	local worktree="$root/.copilot/worktrees/$task"

	if [ ! -d "$worktree" ]; then
		mkdir -p "$root/.copilot/worktrees"
		git worktree add -b "task/$task" "$worktree" ${ref:+"$ref"} || return 1
	fi

	cd "$worktree" || return 1
	copilot --agent "delegate" --yolo "$@"
}
