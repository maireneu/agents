#!/usr/bin/env bash
set -euo pipefail

# Usage: unsync.sh <target_dir> [--backup]

TARGET_DIR="$1"
BACKUP=false
if [ "${2:-}" = "--backup" ]; then
  BACKUP=true
fi

if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Rules directory not found: $TARGET_DIR"
  exit 1
fi

if [ "$BACKUP" = true ]; then
  BACKUP_DIR="${TARGET_DIR}.bak.$(date +%Y%m%d%H%M%S)"
  mv "$TARGET_DIR" "$BACKUP_DIR"
  echo "Backup: $TARGET_DIR → $BACKUP_DIR"
else
  rm -rf "$TARGET_DIR"
  echo "Deleted: $TARGET_DIR"
fi

echo ""
echo "Unsync complete."
