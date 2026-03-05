#!/usr/bin/env bash
# setup-plugins.sh — Auto-install all plugins from maireneu/agents marketplace.
# Register this script in your cloud environment's "pre-session" shell command.
#
# Prerequisites: curl, python3, claude CLI
# Safe to run multiple times (idempotent).

set -euo pipefail

MARKETPLACE_REPO="maireneu/agents"
MARKETPLACE_NAME="mrn-plugins"
REGISTRY_URL="https://raw.githubusercontent.com/${MARKETPLACE_REPO}/main/.claude-plugin/marketplace.json"

echo "[setup-plugins] Registering marketplace: ${MARKETPLACE_REPO}"
if ! claude plugin marketplace add "${MARKETPLACE_REPO}" 2>&1; then
  echo "[setup-plugins] Warning: marketplace registration failed, continuing anyway"
fi

echo "[setup-plugins] Fetching plugin registry..."
registry=$(curl -fsSL "${REGISTRY_URL}") || {
  echo "[setup-plugins] Error: failed to fetch registry from ${REGISTRY_URL}" >&2
  exit 1
}

plugins=$(echo "${registry}" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for p in data.get('plugins', []):
    print(p['name'])
") || {
  echo "[setup-plugins] Error: failed to parse registry JSON (is python3 installed?)" >&2
  exit 1
}

if [[ -z "${plugins}" ]]; then
  echo "[setup-plugins] Error: no plugins found in registry" >&2
  exit 1
fi

while IFS= read -r plugin; do
  echo "[setup-plugins] Installing: ${plugin}@${MARKETPLACE_NAME}"
  if ! claude plugin install "${plugin}@${MARKETPLACE_NAME}" 2>&1; then
    echo "[setup-plugins] Warning: failed to install ${plugin}, skipping" >&2
  fi
done <<< "${plugins}"

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "[setup-plugins] Warning: GITHUB_TOKEN is not set — mrn-mcp plugin will fail to authenticate" >&2
fi

echo "[setup-plugins] Done. Installed plugins:"
echo "${plugins}" | sed 's/^/  - /'
