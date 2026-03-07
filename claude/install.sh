#!/usr/bin/env bash
# Bootstrap installer — downloads and runs setup-plugins.sh from maireneu/agents.
#
# Public repo:
#   curl -fsSL https://raw.githubusercontent.com/maireneu/agents/main/claude/install.sh | bash
#
# Private repo:
#   curl -fsSL -H "Authorization: token $GITHUB_PERSONAL_ACCESS_TOKEN" \
#     https://raw.githubusercontent.com/maireneu/agents/main/claude/install.sh | bash

set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/maireneu/agents/main"
SCRIPT_URL="${REPO_RAW}/claude/setup-plugins.sh"

AUTH_HEADER=()
TOKEN="${GITHUB_PERSONAL_ACCESS_TOKEN:-${GITHUB_TOKEN:-}}"
if [[ -n "$TOKEN" ]]; then
  AUTH_HEADER=(-H "Authorization: token $TOKEN")
fi

echo "[install] Downloading setup-plugins.sh..."
TMPFILE="$(mktemp)"
trap 'rm -f "$TMPFILE"' EXIT

curl -fsSL "${AUTH_HEADER[@]}" "$SCRIPT_URL" -o "$TMPFILE"
chmod +x "$TMPFILE"

echo "[install] Running setup-plugins.sh..."
bash "$TMPFILE"
