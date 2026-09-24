#!/usr/bin/env bash
# ==============================================================================
# launch.sh - Dynamic User Terminal Launcher
# Auto-detects terminal emulator and executes dev-wizard without hardcoded users
# ==============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/bin/ghost-stack"

if [ ! -f "$TARGET_SCRIPT" ]; then
    TARGET_SCRIPT="$SCRIPT_DIR/bin/dev-wizard"
fi

if [ ! -f "$TARGET_SCRIPT" ]; then
    TARGET_SCRIPT="$SCRIPT_DIR/run.sh"
fi

if [ ! -f "$TARGET_SCRIPT" ] && command -v ghost-stack >/dev/null 2>&1; then
    TARGET_SCRIPT="$(command -v ghost-stack)"
elif [ ! -f "$TARGET_SCRIPT" ] && command -v dev-wizard >/dev/null 2>&1; then
    TARGET_SCRIPT="$(command -v dev-wizard)"
fi

chmod +x "$TARGET_SCRIPT" 2>/dev/null || true

# Launch terminal emulator with target script
if command -v qterminal >/dev/null 2>&1; then
    exec qterminal -e "$TARGET_SCRIPT"
elif command -v gnome-terminal >/dev/null 2>&1; then
    exec gnome-terminal -- "$TARGET_SCRIPT"
elif command -v xfce4-terminal >/dev/null 2>&1; then
    exec xfce4-terminal -e "$TARGET_SCRIPT"
elif command -v x-terminal-emulator >/dev/null 2>&1; then
    exec x-terminal-emulator -e "$TARGET_SCRIPT"
else
    exec "$TARGET_SCRIPT"
fi
