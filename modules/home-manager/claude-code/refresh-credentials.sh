config_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
creds_file="$config_dir/.credentials.json"

mkdir -p "$config_dir"

tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT

set +o pipefail
/usr/bin/security dump-keychain 2>&1 \
  | grep -o 'Claude Code-credentials[^"]*' \
  | sort -u \
  | while read -r entry; do
      /usr/bin/security find-generic-password -a "$USER" -s "$entry" -w 2>/dev/null || true
    done \
  | jq -s 'map(select(.claudeAiOauth.expiresAt != null)) | max_by(.claudeAiOauth.expiresAt)' > "$tmpfile"
set -o pipefail

if [ ! -s "$tmpfile" ] || [ "$(cat "$tmpfile")" = "null" ]; then
  echo "claude-refresh-creds: no Claude Code credentials found in Keychain" >&2
  exit 1
fi

install -m 600 "$tmpfile" "$creds_file"
echo "claude-refresh-creds: wrote credentials to $creds_file"
