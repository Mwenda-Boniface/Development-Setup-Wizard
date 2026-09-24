#!/bin/bash
# ==============================================================================
# Ghost-Stack Desktop App & Custom Logo Installer
# Feature: Standalone Desktop Launcher & Icon Generator
# ==============================================================================
set -euo pipefail

C_GREEN="\033[38;5;49m"
C_WHITE="\033[97m"
C_GRAY="\033[90m"
C_RESET="\033[0m"
C_BOLD="\033[1m"
C_YELLOW="\033[33m"

REAL_SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$(dirname "$REAL_SCRIPT_PATH")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

CURRENT_USER="$(id -un 2>/dev/null || whoami)"
USER_HOME="${HOME:-/home/$CURRENT_USER}"

echo -e "\n${C_GREEN}${C_BOLD}[ + ] GHOST-STACK // DESKTOP APP & CUSTOM ICON INSTALLER [ + ]${C_RESET}"
echo -e "${C_GRAY}Configuring native Linux desktop integration for ${C_WHITE}$CURRENT_USER${C_RESET}...\n"

# 1. Ensure assets directory and custom logo exist
ASSETS_DIR="$ROOT_DIR/assets"
mkdir -p "$ASSETS_DIR"

SVG_ICON="$ASSETS_DIR/ghost-stack.svg"
PNG_ICON="$ASSETS_DIR/ghost-stack.png"

if [ ! -f "$SVG_ICON" ] || [ ! -f "$PNG_ICON" ]; then
    echo -e "  ${C_GRAY}Creating custom cybernetic Ghost-Stack logo...${C_RESET}"
    cat << "EOF" > "$SVG_ICON"
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">
  <defs>
    <linearGradient id="bg-grad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#0a0f0d"/>
      <stop offset="50%" stop-color="#0d1814"/>
      <stop offset="100%" stop-color="#050a08"/>
    </linearGradient>
    <linearGradient id="neon-glow" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#00ff88"/>
      <stop offset="50%" stop-color="#00e5ff"/>
      <stop offset="100%" stop-color="#00b468"/>
    </linearGradient>
    <filter id="glow" x="-20%" y="-20%" width="140%" height="140%">
      <feGaussianBlur stdDeviation="6" result="blur"/>
      <feComposite in="SourceGraphic" in2="blur" operator="over"/>
    </filter>
  </defs>
  <rect x="12" y="12" width="232" height="232" rx="48" fill="url(#bg-grad)" stroke="#1a3328" stroke-width="4"/>
  <rect x="16" y="16" width="224" height="224" rx="44" fill="none" stroke="url(#neon-glow)" stroke-width="2" stroke-opacity="0.4"/>
  <path d="M 40 80 L 70 80 L 90 100" fill="none" stroke="#00ff88" stroke-width="2" stroke-opacity="0.25"/>
  <circle cx="40" cy="80" r="3" fill="#00ff88" fill-opacity="0.5"/>
  <path d="M 216 80 L 186 80 L 166 100" fill="none" stroke="#00ff88" stroke-width="2" stroke-opacity="0.25"/>
  <circle cx="216" cy="80" r="3" fill="#00ff88" fill-opacity="0.5"/>
  <path d="M 128 46 C 84 46, 62 82, 62 124 L 62 186 C 62 194, 76 198, 84 188 C 92 178, 102 178, 110 188 C 118 198, 138 198, 146 188 C 154 178, 164 178, 172 188 C 180 198, 194 194, 194 186 L 194 124 C 194 82, 172 46, 128 46 Z" fill="#081c14" stroke="url(#neon-glow)" stroke-width="6" stroke-linejoin="round" filter="url(#glow)"/>
  <ellipse cx="102" cy="118" rx="14" ry="18" fill="#00ffcc" filter="url(#glow)"/>
  <ellipse cx="154" cy="118" rx="14" ry="18" fill="#00ffcc" filter="url(#glow)"/>
  <ellipse cx="104" cy="116" rx="5" ry="7" fill="#ffffff"/>
  <ellipse cx="156" cy="116" rx="5" ry="7" fill="#ffffff"/>
  <path d="M 112 148 L 122 156 L 112 164" fill="none" stroke="#00ff88" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
  <line x1="128" y1="164" x2="142" y2="164" stroke="#00ff88" stroke-width="3" stroke-linecap="round"/>
  <rect x="42" y="206" width="172" height="24" rx="6" fill="#002b1a" stroke="#00ff88" stroke-width="1.5"/>
  <text x="128" y="222" font-family="monospace, monospace" font-size="12" font-weight="900" fill="#00ff88" text-anchor="middle" letter-spacing="3">GHOST-STACK</text>
</svg>
EOF

    if command -v convert >/dev/null 2>&1; then
        convert -background none -density 300 "$SVG_ICON" -resize 256x256 "$PNG_ICON" 2>/dev/null || true
    fi
fi

# 2. Install icons to XDG Standard User Icon Paths
ICON_DIR_SCALABLE="$USER_HOME/.local/share/icons/hicolor/scalable/apps"
ICON_DIR_256="$USER_HOME/.local/share/icons/hicolor/256x256/apps"
ICON_DIR_128="$USER_HOME/.local/share/icons/hicolor/128x128/apps"
ICON_DIR_48="$USER_HOME/.local/share/icons/hicolor/48x48/apps"

mkdir -p "$ICON_DIR_SCALABLE" "$ICON_DIR_256" "$ICON_DIR_128" "$ICON_DIR_48"

cp -f "$SVG_ICON" "$ICON_DIR_SCALABLE/ghost-stack.svg"
if [ -f "$PNG_ICON" ]; then
    cp -f "$PNG_ICON" "$ICON_DIR_256/ghost-stack.png"
    if command -v convert >/dev/null 2>&1; then
        convert "$PNG_ICON" -resize 128x128 "$ICON_DIR_128/ghost-stack.png" 2>/dev/null || true
        convert "$PNG_ICON" -resize 48x48 "$ICON_DIR_48/ghost-stack.png" 2>/dev/null || true
    fi
fi

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -f -t "$USER_HOME/.local/share/icons/hicolor" 2>/dev/null || true
fi

echo -e "  ${C_GREEN}[ OK ]${C_RESET} Custom logo installed to ${C_WHITE}~/.local/share/icons/hicolor${C_RESET}"

# 3. Create Launch Wrapper
BIN_PATH="$USER_HOME/.local/bin/ghost-stack"
if [ ! -f "$BIN_PATH" ] && [ -f "$ROOT_DIR/bin/ghost-stack" ]; then
    mkdir -p "$USER_HOME/.local/bin"
    ln -sf "$ROOT_DIR/bin/ghost-stack" "$BIN_PATH"
fi

# 4. Generate Desktop Entries
APP_DIR="$USER_HOME/.local/share/applications"
DESKTOP_DIR="$USER_HOME/Desktop"
mkdir -p "$APP_DIR" "$DESKTOP_DIR"

APP_DESKTOP="$APP_DIR/ghost-stack.desktop"
USER_DESKTOP="$DESKTOP_DIR/Ghost-Stack.desktop"

# Prefer custom PNG icon path if available, or named icon
TARGET_ICON="ghost-stack"
if [ -f "$PNG_ICON" ]; then
    TARGET_ICON="$PNG_ICON"
fi

cat << EOF > "$APP_DESKTOP"
[Desktop Entry]
Version=1.0
Type=Application
Name=Ghost-Stack
GenericName=Development Environment & Toolchain Orchestrator
Comment=Launch Ghost-Stack Development Orchestrator & System Cleaner
Exec=bash -c 'if command -v ghost-stack >/dev/null 2>&1; then exec qterminal -e ghost-stack || exec x-terminal-emulator -e ghost-stack || exec bash -c ghost-stack; else exec "$ROOT_DIR/bin/ghost-stack"; fi'
Icon=${TARGET_ICON}
Terminal=false
Categories=Development;System;Utility;
StartupNotify=true
Keywords=ghost;stack;dev;tools;cleaner;doctor;
EOF

cp -f "$APP_DESKTOP" "$USER_DESKTOP"
cp -f "$APP_DESKTOP" "$ROOT_DIR/Ghost-Stack.desktop"

chmod +x "$APP_DESKTOP" "$USER_DESKTOP" "$ROOT_DIR/Ghost-Stack.desktop"

if command -v gio >/dev/null 2>&1; then
    gio set "$USER_DESKTOP" metadata::trusted true 2>/dev/null || true
fi

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$APP_DIR" 2>/dev/null || true
fi

echo -e "  ${C_GREEN}[ OK ]${C_RESET} System Application entry created at ${C_WHITE}$APP_DESKTOP${C_RESET}"
echo -e "  ${C_GREEN}[ OK ]${C_RESET} Desktop shortcut created at ${C_WHITE}$USER_DESKTOP${C_RESET}"
echo -e "\n${C_GREEN}${C_BOLD}[ SUCCESS ] Ghost-Stack desktop app is ready!${C_RESET}"
echo -e "You can now launch Ghost-Stack directly from your Desktop or App Launcher menu with its custom logo.\n"
