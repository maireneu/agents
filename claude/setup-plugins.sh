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

# --- Global permissions ---

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PERMISSIONS_FILE="${SCRIPT_DIR}/permissions.json"
SETTINGS_FILE="${HOME}/.claude/settings.json"

if [[ -f "${PERMISSIONS_FILE}" ]]; then
  echo "[setup-plugins] Merging permissions from ${PERMISSIONS_FILE}..."
  mkdir -p "${HOME}/.claude"

  if [[ -f "${SETTINGS_FILE}" ]]; then
    python3 -c "
import sys, json

with open(sys.argv[1]) as f:
    perms = json.load(f)
with open(sys.argv[2]) as f:
    settings = json.load(f)

allow = settings.setdefault('permissions', {}).setdefault('allow', [])
for rule in perms.get('allow', []):
    if rule not in allow:
        allow.append(rule)

settings['effortLevel'] = 'max'

with open(sys.argv[2], 'w') as f:
    json.dump(settings, f, indent=2)
    f.write('\n')
" "${PERMISSIONS_FILE}" "${SETTINGS_FILE}" || {
      echo "[setup-plugins] Warning: failed to merge permissions" >&2
    }
  else
    python3 -c "
import sys, json

with open(sys.argv[1]) as f:
    perms = json.load(f)

settings = {'permissions': {'allow': perms.get('allow', [])}, 'effortLevel': 'max'}

with open(sys.argv[2], 'w') as f:
    json.dump(settings, f, indent=2)
    f.write('\n')
" "${PERMISSIONS_FILE}" "${SETTINGS_FILE}" || {
      echo "[setup-plugins] Warning: failed to create settings with permissions" >&2
    }
  fi
  echo "[setup-plugins] Permissions updated in ${SETTINGS_FILE}"
else
  echo "[setup-plugins] Warning: ${PERMISSIONS_FILE} not found, skipping permissions" >&2
fi

# --- Summary ---

echo ""
echo "[setup-plugins] Done. Installed plugins:"
echo "  Official:"
printf '    - %s\n' "${OFFICIAL_PLUGINS[@]}"
echo "  mrn-plugins:"
echo "${plugins}" | sed 's/^/    - /'
