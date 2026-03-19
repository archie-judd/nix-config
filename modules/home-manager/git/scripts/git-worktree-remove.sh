set -euo pipefail

name="$1"
if [ -z "$name" ]; then
	echo "Usage: git-worktree-remove <worktree-name>" >&2
	exit 1
fi

matches=$(git worktree list --porcelain 2>/dev/null | grep "^worktree " | cut -d' ' -f2 | grep -E "(^|/)$name$")

if [ -z "$matches" ]; then
	echo "No worktree found matching '$name'" >&2
	exit 1
fi

if [ "$(echo "$matches" | wc -l)" -gt 1 ]; then
	echo "Ambiguous worktree name '$name'. Matches:" >&2
	echo "$matches" >&2
	exit 1
fi

git worktree remove "$matches"
