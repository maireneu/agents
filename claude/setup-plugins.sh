#!/usr/bin/env bash
# setup-plugins.sh — Auto-install all plugins from maireneu/agents marketplace.
# Register this script in your cloud environment's "pre-session" shell command.

set -euo pipefail

MARKETPLACE_REPO="maireneu/agents"
MARKETPLACE_NAME="mrn-plugins"
REGISTRY_URL="https://raw.githubusercontent.com/${MARKETPLACE_REPO}/main/.claude-plugin/marketplace.json"

echo "[setup-plugins] Registering marketplace: ${MARKETPLACE_REPO}"
claude plugin marketplace add "${MARKETPLACE_REPO}" 2>/dev/null || true

echo "[setup-plugins] Fetching plugin registry..."
registry=$(curl -fsSL "${REGISTRY_URL}")

plugins=$(echo "${registry}" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for p in data.get('plugins', []):
    print(p['name'])
")

for plugin in ${plugins}; do
  echo "[setup-plugins] Installing: ${plugin}@${MARKETPLACE_NAME}"
  claude plugin install "${plugin}@${MARKETPLACE_NAME}" 2>/dev/null || {
    echo "[setup-plugins] Warning: failed to install ${plugin}, skipping"
  }
done

echo "[setup-plugins] Done. Installed plugins:"
echo "${plugins}" | sed 's/^/  - /'
