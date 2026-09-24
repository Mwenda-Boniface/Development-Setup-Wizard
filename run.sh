#!/usr/bin/env bash
# ==============================================================================
# Ghost-Stack Root Launcher
# ==============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/bin/ghost-stack" "$@"
