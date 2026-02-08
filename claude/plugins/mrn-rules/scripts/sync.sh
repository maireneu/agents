#!/usr/bin/env bash
set -euo pipefail

# Usage: sync.sh [--backup] <source_dir> <target_dir> <file1> [file2] ...

BACKUP=false
if [ "${1:-}" = "--backup" ]; then
  BACKUP=true
  shift
fi

SOURCE_DIR="$1"
TARGET_DIR="$2"
shift 2
FILES=("$@")

if [ ${#FILES[@]} -eq 0 ]; then
  echo "Error: No rule files specified"
  exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory not found: $SOURCE_DIR"
  exit 1
fi

# Handle existing rules
if [ -d "$TARGET_DIR" ]; then
  if [ "$BACKUP" = true ]; then
    BACKUP_DIR="${TARGET_DIR}.bak.$(date +%Y%m%d%H%M%S)"
    mv "$TARGET_DIR" "$BACKUP_DIR"
    echo "Backup: $TARGET_DIR → $BACKUP_DIR"
  else
    rm -rf "$TARGET_DIR"
  fi
fi

# Create target directory
mkdir -p "$TARGET_DIR"

# Copy each rule file
SYNCED=0
for file in "${FILES[@]}"; do
  src="$SOURCE_DIR/$file"
  dst="$TARGET_DIR/$file"

  if [ ! -f "$src" ]; then
    echo "Warning: File not found, skipping: $file"
    continue
  fi

  # Create subdirectory if needed
  dst_dir=$(dirname "$dst")
  mkdir -p "$dst_dir"

  cp "$src" "$dst"
  echo "  Synced: $file"
  SYNCED=$((SYNCED + 1))
done

echo ""
echo "Sync complete: $SYNCED rule(s) → $TARGET_DIR"
