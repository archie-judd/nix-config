for tag in "$@"; do
	git tag -d "$tag"
	git push -d origin "$tag"
done
