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
  feature-dev
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

# --- Marketplace registration ---

OFFICIAL_MARKETPLACE="anthropics/claude-plugins-official"
MARKETPLACE_REPO="maireneu/agents"
MARKETPLACE_NAME="mrn-plugins"
REGISTRY_URL="https://raw.githubusercontent.com/${MARKETPLACE_REPO}/main/.claude-plugin/marketplace.json"

echo "[setup-plugins] Registering marketplace: ${OFFICIAL_MARKETPLACE}"
if ! claude plugin marketplace add "${OFFICIAL_MARKETPLACE}" 2>&1; then
  echo "[setup-plugins] Warning: official marketplace registration failed, continuing anyway"
fi

echo "[setup-plugins] Registering marketplace: ${MARKETPLACE_REPO}"
if ! claude plugin marketplace add "${MARKETPLACE_REPO}" 2>&1; then
  echo "[setup-plugins] Warning: mrn-plugins marketplace registration failed, continuing anyway"
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

# --- Global rules (from remote repo) ---

RULES_API_URL="https://api.github.com/repos/${MARKETPLACE_REPO}/git/trees/main?recursive=1"
RULES_RAW_BASE="https://raw.githubusercontent.com/${MARKETPLACE_REPO}/main"
RULES_DEST="${HOME}/.claude/rules"

echo "[setup-plugins] Syncing global rules from ${MARKETPLACE_REPO}..."
mkdir -p "${RULES_DEST}"

rule_files=$(curl -fsSL "${RULES_API_URL}" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for item in data.get('tree', []):
    path = item['path']
    if path.startswith('rules/') and path.endswith('.md') and item['type'] == 'blob':
        print(path)
") || {
  echo "[setup-plugins] Warning: failed to fetch rules tree" >&2
  rule_files=""
}

rules_count=0
while IFS= read -r rule_path; do
  [[ -z "${rule_path}" ]] && continue
  rel_path="${rule_path#rules/}"
  dest_path="${RULES_DEST}/${rel_path}"
  mkdir -p "$(dirname "${dest_path}")"
  if curl -fsSL "${RULES_RAW_BASE}/${rule_path}" -o "${dest_path}" 2>/dev/null; then
    rules_count=$((rules_count + 1))
  else
    echo "[setup-plugins] Warning: failed to download ${rule_path}" >&2
  fi
done <<< "${rule_files}"

echo "[setup-plugins] Synced ${rules_count} rule files to ${RULES_DEST}"

# --- Global permissions ---

PERMISSIONS_URL="${RULES_RAW_BASE}/claude/permissions.json"
SETTINGS_FILE="${HOME}/.claude/settings.json"

echo "[setup-plugins] Downloading permissions.json from ${MARKETPLACE_REPO}..."
PERMISSIONS_TMP="$(mktemp)"
trap 'rm -f "$PERMISSIONS_TMP"' EXIT

if curl -fsSL "${PERMISSIONS_URL}" -o "${PERMISSIONS_TMP}" 2>/dev/null; then
  echo "[setup-plugins] Merging permissions into ${SETTINGS_FILE}..."
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
" "${PERMISSIONS_TMP}" "${SETTINGS_FILE}" || {
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
" "${PERMISSIONS_TMP}" "${SETTINGS_FILE}" || {
      echo "[setup-plugins] Warning: failed to create settings with permissions" >&2
    }
  fi
  echo "[setup-plugins] Permissions updated in ${SETTINGS_FILE}"
else
  echo "[setup-plugins] Warning: failed to download permissions.json, skipping permissions" >&2
fi

# --- Summary ---

echo ""
echo "[setup-plugins] Done. Installed plugins:"
echo "  Official:"
printf '    - %s\n' "${OFFICIAL_PLUGINS[@]}"
echo "  mrn-plugins:"
echo "${plugins}" | sed 's/^/    - /'
