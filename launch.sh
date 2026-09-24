#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/run.sh"

if [ ! -f "$TARGET_SCRIPT" ]; then
    TARGET_SCRIPT="/home/bonnie/Desktop/setup-wizard/run.sh"
fi

chmod +x "$TARGET_SCRIPT"

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
