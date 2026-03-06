#!/usr/bin/env bash
# setup-plugins.sh — Auto-install official Claude plugins and maireneu/agents marketplace plugins.
# Register this script in your cloud environment's "pre-session" shell command.
#
# Prerequisites: curl, python3, claude CLI
# Safe to run multiple times (idempotent).

set -euo pipefail

# --- Official Claude plugins (claude-plugins-official) ---

OFFICIAL_PLUGINS=(
  code-review
  pr-review-toolkit
  superpowers
  github
  typescript-lsp
  pyright-lsp
  gopls-lsp
  rust-analyzer-lsp
  kotlin-lsp
)

echo "[setup-plugins] Installing official Claude plugins..."
for plugin in "${OFFICIAL_PLUGINS[@]}"; do
  echo "[setup-plugins] Installing: ${plugin}@claude-plugins-official"
  if ! claude plugin install "${plugin}@claude-plugins-official" 2>&1; then
    echo "[setup-plugins] Warning: failed to install ${plugin}, skipping" >&2
  fi
done

if [[ -z "${GITHUB_PERSONAL_ACCESS_TOKEN:-}" ]]; then
  echo "[setup-plugins] Warning: GITHUB_PERSONAL_ACCESS_TOKEN is not set — github plugin will fail to authenticate" >&2
fi

# --- mrn-plugins marketplace ---

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

# --- Summary ---

echo ""
echo "[setup-plugins] Done. Installed plugins:"
echo "  Official:"
printf '    - %s\n' "${OFFICIAL_PLUGINS[@]}"
echo "  mrn-plugins:"
echo "${plugins}" | sed 's/^/    - /'
