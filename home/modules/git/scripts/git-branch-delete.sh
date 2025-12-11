for branch in "$@"; do
	git branch -D "$branch"
	git push -d origin "$branch"
done
