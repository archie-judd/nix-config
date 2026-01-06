function __git_review_pr_cleanup() {
	local PREVIOUS_BRANCH
	PREVIOUS_BRANCH=$(git config review.previousbranch)

	if [ -z "$PREVIOUS_BRANCH" ]; then
		echo "Error: No previous branch found. Please specify: git_review_pr_cleanup <branch>"
		return 1
	fi

	git reset --hard HEAD
	git checkout "$PREVIOUS_BRANCH"
	git config --unset review.previousbranch

	echo "Cleanup complete. Returned to $PREVIOUS_BRANCH"
}

function git_review_pr() {

	if [ "$1" = "--cleanup" ] || [ "$1" = "-c" ]; then
		__git_review_pr_cleanup
		return $?
	fi

	if [ "$#" -ne 2 ]; then
		echo "Usage: git-review-pr <base-branch> <feature-branch>"
		return 1
	fi

	# Check for uncommitted changes (staged or unstaged)
	# Allow untracked files
	if ! git diff --quiet || ! git diff --cached --quiet; then
		echo "Error: You have uncommitted changes. Please commit or stash them first."
		git status --short
		return 1
	fi

	local BASE_BRANCH=$1
	local FEATURE_BRANCH=$2
	local PREVIOUS_BRANCH

	# Capture the current branch
	PREVIOUS_BRANCH=$(git rev-parse --abbrev-ref HEAD)

	git fetch origin "$BASE_BRANCH" "$FEATURE_BRANCH" || return 1
	git checkout "$BASE_BRANCH" || return 1
	git pull origin "$BASE_BRANCH" || return 1
	git checkout "$FEATURE_BRANCH" || return 1
	git pull origin "$FEATURE_BRANCH" || return 1
	git reset --soft "$(git merge-base origin/"$BASE_BRANCH" HEAD)"

	git config review.previousbranch "$PREVIOUS_BRANCH"

	echo "PR review setup complete."
	echo "To cleanup: git-review-pr -c"
}

git_review_pr "$@"
