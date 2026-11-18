#!/usr/bin/env bash
# scripts/install.sh — install shae-log-analyzer
# Symlinks src/analyzer.pl into ~/.local/bin/shae-log-analyzer.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_DIR/src/analyzer.pl"
TARGET="$HOME/.local/bin/shae-log-analyzer"

mkdir -p "$HOME/.local/bin"

ln -sf "$SRC" "$TARGET"
chmod +x "$SRC"

echo "Installed shae-log-analyzer -> $TARGET"
echo "Ensure $HOME/.local/bin is on your PATH, then run:"
echo "  shae-log-analyzer /var/log/apache2/access.log"
echo "  shae-log-analyzer access.log | head -n 80"
