set -euo pipefail

names=()
flags=()
for arg in "$@"; do
	case "$arg" in
	-*) flags+=("$arg") ;;
	*) names+=("$arg") ;;
	esac
done

if [ "${#names[@]}" -eq 0 ]; then
	echo "Usage: git-worktree-remove <worktree-name>... [flags...]" >&2
	exit 1
fi

all=$(git worktree list --porcelain 2>/dev/null | grep "^worktree " | cut -d' ' -f2)

paths=()
for name in "${names[@]}"; do
	matches=$(echo "$all" | grep -E "(^|/)$name$" || true)

	if [ -z "$matches" ]; then
		echo "No worktree found matching '$name'" >&2
		exit 1
	fi

	if [ "$(echo "$matches" | wc -l)" -gt 1 ]; then
		echo "Ambiguous worktree name '$name'. Matches:" >&2
		echo "$matches" >&2
		exit 1
	fi

	paths+=("$matches")
done

status=0
for path in "${paths[@]}"; do
	git worktree remove "${flags[@]}" "$path" || status=1
done
exit $status
