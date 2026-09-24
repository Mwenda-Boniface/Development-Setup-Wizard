#!/usr/bin/env bash
# ==============================================================================
# 🚀 MODULAR DEV-ENVIRONMENT INSTALLER & DIAGNOSTIC MANAGER
# ==============================================================================
# Supports:
#   1) Android Development
#   2) iOS Development (Linux Tools & Cross-Platform)
#   3) Web Development
#   4) AI & Machine Learning Development
#   5) Development Softwares & IDEs (VS Code, Postman, etc.)
#   6) Core System Tools & Git / GitHub
#
# Feature: Scans tools under selected field, displays [INSTALLED] / [NOT INSTALLED],
# lists uninstalled tools, and allows comma-separated installation (e.g. 1,2,5 or 'all').
# ==============================================================================

# Ensure bash
if [ -z "$BASH_VERSION" ]; then
    exec bash "$0" "$@"
fi

# Configuration Defaults
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEV_DIR="$HOME/development"
FLUTTER_DIR="$DEV_DIR/flutter"
ANDROID_DIR="$HOME/Android/Sdk"
JAVA_PREFERRED_PATH="/usr/lib/jvm/java-21-openjdk-amd64"

# Color Palette
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

# Visual Badges
badge_ok()        { echo -e "  ${GREEN}${BOLD}[ ✓ INSTALLED     ]${NC} $1"; }
badge_missing()   { echo -e "  ${RED}${BOLD}[ ✗ NOT INSTALLED ]${NC} $1"; }
badge_warn()      { echo -e "  ${YELLOW}${BOLD}[ ⚠ ATTENTION     ]${NC} $1"; }
badge_info()      { echo -e "  ${CYAN}${BOLD}[ ℹ INFO          ]${NC} $1"; }

# Sync Environment into current shell
sync_env() {
    if [ -d "$JAVA_PREFERRED_PATH" ]; then
        export JAVA_HOME="$JAVA_PREFERRED_PATH"
    fi
    export ANDROID_HOME="$ANDROID_DIR"
    export PATH="$HOME/.local/bin:$FLUTTER_DIR/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:${JAVA_HOME:-/usr}/bin:$PATH"
}
sync_env

# Ensure PATHs are saved to ~/.zshrc and ~/.bashrc
persist_env() {
    local env_block="
# --- DEV ENVIRONMENT VARIABLES ---
export JAVA_HOME=\"${JAVA_PREFERRED_PATH}\"
export ANDROID_HOME=\"\$HOME/Android/Sdk\"
export PATH=\"\$HOME/.local/bin:\$HOME/development/flutter/bin:\$ANDROID_HOME/cmdline-tools/latest/bin:\$ANDROID_HOME/platform-tools:\$JAVA_HOME/bin:\$PATH\"
# ---------------------------------"

    for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
        if [ -f "$rc" ]; then
            if ! grep -q "ANDROID_HOME" "$rc"; then
                echo "$env_block" >> "$rc"
            fi
        fi
    done
}
persist_env

draw_header() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "  ╔═══════════════════════════════════════════════════════════════════╗"
    echo "  ║        MODULAR DEV-ENVIRONMENT INSTALLER & TOOLCHAIN MANAGER      ║"
    echo "  ║             Multi-Category Scanner & Selective Installer          ║"
    echo "  ╚═══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

pause() {
    echo ""
    echo -e "${DIM}Press [Enter] to continue...${NC}"
    read -r || true
}

# ==============================================================================
# TOOL DEFINITIONS & CHECK FUNCTIONS
# ==============================================================================

# --- ANDROID ---
check_java21() {
    if [ -d "$JAVA_PREFERRED_PATH" ] || (command -v java >/dev/null && java -version 2>&1 | grep -q "21\."); then
        return 0
    fi
    return 1
}
install_java21() {
    echo -e "${YELLOW}Installing OpenJDK 21 LTS...${NC}"
    sudo apt update && sudo apt install -y openjdk-21-jdk
    sync_env
}

check_android_cmdline() {
    [ -x "$ANDROID_DIR/cmdline-tools/latest/bin/sdkmanager" ]
}
install_android_cmdline() {
    echo -e "${YELLOW}Downloading Google Android Command-Line Tools...${NC}"
    mkdir -p "$ANDROID_DIR/cmdline-tools" /tmp
    local zip_path="/tmp/cmdline-tools.zip"
    curl -L -o "$zip_path" "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
    unzip -q -o "$zip_path" -d /tmp/cmdline-extract
    mkdir -p "$ANDROID_DIR/cmdline-tools/latest"
    cp -r /tmp/cmdline-extract/cmdline-tools/* "$ANDROID_DIR/cmdline-tools/latest/"
    rm -rf /tmp/cmdline-extract "$zip_path"
    sync_env
}

check_android_platform_tools() {
    [ -x "$ANDROID_DIR/platform-tools/adb" ] || command -v adb >/dev/null 2>&1
}
install_android_platform_tools() {
    echo -e "${YELLOW}Installing Android platform-tools (adb)...${NC}"
    check_android_cmdline || install_android_cmdline
    sync_env
    echo "y" | "$ANDROID_DIR/cmdline-tools/latest/bin/sdkmanager" "platform-tools"
}

check_android_platforms() {
    [ -d "$ANDROID_DIR/platforms/android-36" ] || [ -d "$ANDROID_DIR/platforms/android-34" ]
}
install_android_platforms() {
    echo -e "${YELLOW}Installing Android SDK Platforms (API 34 & 36)...${NC}"
    check_android_cmdline || install_android_cmdline
    sync_env
    echo "y" | "$ANDROID_DIR/cmdline-tools/latest/bin/sdkmanager" "platforms;android-36" "platforms;android-34"
}

check_android_build_tools() {
    [ -d "$ANDROID_DIR/build-tools/28.0.3" ] || [ -d "$ANDROID_DIR/build-tools/34.0.0" ]
}
install_android_build_tools() {
    echo -e "${YELLOW}Installing Android Build-Tools (28.0.3 & 34.0.0)...${NC}"
    check_android_cmdline || install_android_cmdline
    sync_env
    echo "y" | "$ANDROID_DIR/cmdline-tools/latest/bin/sdkmanager" "build-tools;28.0.3" "build-tools;34.0.0"
}

check_flutter() {
    [ -x "$FLUTTER_DIR/bin/flutter" ] || command -v flutter >/dev/null 2>&1
}
install_flutter() {
    echo -e "${YELLOW}Cloning Flutter SDK (stable branch)...${NC}"
    mkdir -p "$DEV_DIR"
    if [ ! -d "$FLUTTER_DIR" ]; then
        git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"
    else
        cd "$FLUTTER_DIR" && git pull || true
    fi
    sync_env
    "$FLUTTER_DIR/bin/flutter" precache
    "$FLUTTER_DIR/bin/flutter" config --android-sdk "$ANDROID_DIR" || true
    yes | "$ANDROID_DIR/cmdline-tools/latest/bin/sdkmanager" --licenses || true
}

# --- IOS (LINUX COMPATIBILITY & CROSS-PLATFORM) ---
check_usbmuxd() {
    command -v usbmuxd >/dev/null 2>&1
}
install_usbmuxd() {
    echo -e "${YELLOW}Installing usbmuxd (USB daemon for iOS)...${NC}"
    sudo apt update && sudo apt install -y usbmuxd
}

check_libimobiledevice() {
    command -v ideviceinfo >/dev/null 2>&1 || dpkg -s libimobiledevice6 >/dev/null 2>&1
}
install_libimobiledevice() {
    echo -e "${YELLOW}Installing libimobiledevice...${NC}"
    sudo apt update && sudo apt install -y libimobiledevice6 libimobiledevice-utils
}

check_ideviceinstaller() {
    command -v ideviceinstaller >/dev/null 2>&1
}
install_ideviceinstaller() {
    echo -e "${YELLOW}Installing ideviceinstaller...${NC}"
    sudo apt update && sudo apt install -y ideviceinstaller
}

check_cocoapods() {
    command -v pod >/dev/null 2>&1
}
install_cocoapods() {
    echo -e "${YELLOW}Installing CocoaPods & Ruby environment...${NC}"
    sudo apt update && sudo apt install -y ruby-full build-essential
    sudo gem install cocoapods || true
}

# --- WEB DEVELOPMENT ---
check_nodejs() {
    command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1
}
install_nodejs() {
    echo -e "${YELLOW}Installing Node.js LTS and npm...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
}

check_pnpm_yarn() {
    command -v pnpm >/dev/null 2>&1 && command -v yarn >/dev/null 2>&1
}
install_pnpm_yarn() {
    echo -e "${YELLOW}Installing pnpm and yarn package managers globally...${NC}"
    sudo npm install -g pnpm yarn
}

check_postgresql() {
    command -v psql >/dev/null 2>&1
}
install_postgresql() {
    echo -e "${YELLOW}Installing PostgreSQL client and server...${NC}"
    sudo apt update && sudo apt install -y postgresql postgresql-contrib
    sudo systemctl enable --now postgresql || true
}

check_redis() {
    command -v redis-server >/dev/null 2>&1 && command -v redis-cli >/dev/null 2>&1
}
install_redis() {
    echo -e "${YELLOW}Installing Redis server and CLI...${NC}"
    sudo apt update && sudo apt install -y redis-server redis-tools
    sudo systemctl enable --now redis-server || true
}

check_docker() {
    command -v docker >/dev/null 2>&1
}
install_docker() {
    echo -e "${YELLOW}Installing Docker Engine & Docker Compose...${NC}"
    sudo apt update && sudo apt install -y docker.io docker-compose-plugin docker-compose
    sudo systemctl enable --now docker || true
    sudo usermod -aG docker "$USER" || true
    echo -e "${GREEN}Docker installed. (Note: group membership activates on next login).${NC}"
}

check_chrome() {
    command -v google-chrome >/dev/null 2>&1 || command -v chromium >/dev/null 2>&1
}
install_chrome() {
    echo -e "${YELLOW}Installing Chromium Browser...${NC}"
    sudo apt update && sudo apt install -y chromium
}

# --- AI & MACHINE LEARNING ---
check_python_env() {
    command -v python3 >/dev/null 2>&1 && command -v pip3 >/dev/null 2>&1
}
install_python_env() {
    echo -e "${YELLOW}Installing Python 3, pip, and venv...${NC}"
    sudo apt update && sudo apt install -y python3 python3-pip python3-venv python3-full
}

check_ollama() {
    command -v ollama >/dev/null 2>&1
}
install_ollama() {
    echo -e "${YELLOW}Installing Ollama (Local AI & LLM Runner)...${NC}"
    curl -fsSL https://ollama.com/install.sh | sh
}

check_jupyter() {
    command -v jupyter >/dev/null 2>&1 || python3 -c "import jupyterlab" >/dev/null 2>&1
}
install_jupyter() {
    echo -e "${YELLOW}Installing JupyterLab & Jupyter Notebook...${NC}"
    python3 -m pip install --user --upgrade jupyterlab notebook --break-system-packages || true
}

check_ai_stack() {
    python3 -c "import numpy, pandas, sklearn" >/dev/null 2>&1
}
install_ai_stack() {
    echo -e "${YELLOW}Installing Core AI Stack (NumPy, Pandas, Scikit-Learn, Matplotlib, PyTorch)...${NC}"
    python3 -m pip install --user --upgrade numpy pandas scikit-learn matplotlib scipy torch torchvision --break-system-packages || true
}

check_huggingface() {
    command -v huggingface-cli >/dev/null 2>&1 || python3 -c "import huggingface_hub" >/dev/null 2>&1
}
install_huggingface() {
    echo -e "${YELLOW}Installing Hugging Face Hub CLI...${NC}"
    python3 -m pip install --user --upgrade "huggingface_hub[cli]" --break-system-packages || true
}

# --- DEVELOPMENT SOFTWARES & TOOLS ---
check_vscode() {
    command -v code >/dev/null 2>&1 || command -v code-oss >/dev/null 2>&1
}
install_vscode() {
    echo -e "${YELLOW}Installing Visual Studio Code...${NC}"
    local deb_path="/tmp/vscode.deb"
    curl -L -o "$deb_path" "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    sudo apt install -y "$deb_path" || sudo dpkg -i "$deb_path" || sudo apt install -f -y
    rm -f "$deb_path"
}

check_gh_cli() {
    command -v gh >/dev/null 2>&1
}
install_gh_cli() {
    echo -e "${YELLOW}Installing GitHub CLI (gh)...${NC}"
    sudo mkdir -p -m 755 /etc/apt/keyrings
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update && sudo apt install -y gh
}

check_postman() {
    command -v postman >/dev/null 2>&1 || [ -d "/opt/Postman" ]
}
install_postman() {
    echo -e "${YELLOW}Installing Postman (API Development Client)...${NC}"
    local tar_path="/tmp/postman.tar.gz"
    curl -L -o "$tar_path" "https://dl.pstmn.io/download/latest/linux_64"
    sudo tar -xzf "$tar_path" -C /opt
    sudo ln -sf /opt/Postman/Postman /usr/local/bin/postman
    rm -f "$tar_path"
    
    # Desktop launcher
    cat << EOF | sudo tee /usr/share/applications/postman.desktop > /dev/null
[Desktop Entry]
Name=Postman
GenericName=API Client
Comment=REST & GraphQL API Development Environment
Exec=/opt/Postman/Postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOF
    echo -e "${GREEN}Postman installed successfully!${NC}"
}

check_dbeaver() {
    command -v dbeaver >/dev/null 2>&1 || dpkg -s dbeaver-ce >/dev/null 2>&1
}
install_dbeaver() {
    echo -e "${YELLOW}Installing DBeaver Community (Universal Database Tool)...${NC}"
    local deb_path="/tmp/dbeaver.deb"
    curl -L -o "$deb_path" "https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb"
    sudo apt install -y "$deb_path" || sudo dpkg -i "$deb_path" || sudo apt install -f -y
    rm -f "$deb_path"
}

check_git_gui() {
    command -v git-cola >/dev/null 2>&1 || command -v gitk >/dev/null 2>&1
}
install_git_gui() {
    echo -e "${YELLOW}Installing Git GUI Tools (Git Cola & Gitk)...${NC}"
    sudo apt update && sudo apt install -y git-cola gitk
}

check_tmux_htop() {
    command -v tmux >/dev/null 2>&1 && command -v htop >/dev/null 2>&1
}
install_tmux_htop() {
    echo -e "${YELLOW}Installing Tmux and Htop...${NC}"
    sudo apt update && sudo apt install -y tmux htop
}

# --- CORE SYSTEM & GIT ---
check_git_configured() {
    command -v git >/dev/null 2>&1 && [ -n "$(git config --global user.name 2>/dev/null)" ]
}
install_git_configured() {
    echo -e "${YELLOW}Configuring Git Identity...${NC}"
    read -rp "Enter your Full Name (e.g. Mwenda Boniface): " g_name
    read -rp "Enter your GitHub Email: " g_email
    [ -n "$g_name" ] && git config --global user.name "$g_name"
    [ -n "$g_email" ] && git config --global user.email "$g_email"
    git config --global init.defaultBranch main
}

check_github_ssh() {
    [ -f "$HOME/.ssh/id_ed25519" ]
}
install_github_ssh() {
    echo -e "${YELLOW}Generating Ed25519 SSH Key for GitHub...${NC}"
    local email
    email=$(git config --global user.email 2>/dev/null || echo "developer@example.com")
    mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$email" -f "$HOME/.ssh/id_ed25519" -N ""
    chmod 600 "$HOME/.ssh/id_ed25519"
    chmod 644 "$HOME/.ssh/id_ed25519.pub"
    echo -e "\n${CYAN}Your Public Key:${NC}"
    cat "$HOME/.ssh/id_ed25519.pub"
    echo -e "${DIM}Copy the key above to: https://github.com/settings/keys${NC}\n"
    read -rp "Press [Enter] to test connection..."
    ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5 -T git@github.com 2>&1 || true
}

check_build_essentials() {
    command -v clang >/dev/null 2>&1 && command -v cmake >/dev/null 2>&1 && command -v ninja >/dev/null 2>&1 && command -v pkg-config >/dev/null 2>&1
}
install_build_essentials() {
    echo -e "${YELLOW}Installing C/C++ Build Essentials (clang, cmake, ninja, gtk-3, lzma)...${NC}"
    sudo apt update && sudo apt install -y clang cmake ninja-build pkg-config build-essential libgtk-3-dev liblzma-dev mesa-utils curl git unzip zip xz-utils
}

# ==============================================================================
# CATEGORY MANAGEMENT & INTERACTIVE DISPATCHER
# ==============================================================================

# Generic Handler for a Category
# Args:
#   $1 = Category Title
#   $2 = Array name containing: "Tool Name|check_fn|install_fn"
handle_category() {
    local cat_title="$1"
    local cat_array_name="$2"
    
    # Indirect array reference
    eval "local tool_list=(\"\${${cat_array_name}[@]}\")"
    local total_tools=${#tool_list[@]}

    while true; do
        draw_header
        echo -e "  ${BOLD}${PURPLE}CATEGORY: $cat_title${NC}"
        echo -e "  ${DIM}Scanning installed tools...${NC}\n"

        local installed_count=0
        local uninstalled_indexes=()
        local uninstalled_names=()
        local uninstalled_installers=()

        # Step 1: Scan and display status for every tool
        for idx in "${!tool_list[@]}"; do
            local item="${tool_list[$idx]}"
            local name="${item%%|*}"
            local rest="${item#*|}"
            local check_fn="${rest%%|*}"
            local install_fn="${rest#*|}"

            echo -n "  "
            if $check_fn; then
                badge_ok "$name"
                ((installed_count++))
            else
                badge_missing "$name"
                uninstalled_indexes+=("$idx")
                uninstalled_names+=("$name")
                uninstalled_installers+=("$install_fn")
            fi
        done

        echo ""
        echo -e "  ${DIM}─────────────────────────────────────────────────────────────────${NC}"
        echo -e "  ${BOLD}Status:${NC} ${GREEN}$installed_count${NC} of ${BOLD}$total_tools${NC} tools installed."
        echo -e "  ${DIM}─────────────────────────────────────────────────────────────────${NC}"

        # If all are installed
        if [ ${#uninstalled_names[@]} -eq 0 ]; then
            echo -e "\n  ${GREEN}${BOLD}✓ All tools in this category are installed and ready!${NC}\n"
            echo -e "  ${CYAN}[R]${NC} Reinstall / Run setup again for a specific tool"
            echo -e "  ${CYAN}[0]${NC} Back to Main Menu"
            echo ""
            echo -n "  Enter choice: "
            read -r r_choice || return 0
            if [[ "$r_choice" =~ ^[Rr]$ ]]; then
                echo -e "\n  Select tool number to re-run (1-$total_tools): "
                read -r re_idx || continue
                if [[ "$re_idx" =~ ^[0-9]+$ ]] && [ "$re_idx" -ge 1 ] && [ "$re_idx" -le "$total_tools" ]; then
                    local target_item="${tool_list[$((re_idx-1))]}"
                    local t_rest="${target_item#*|}"
                    local t_install="${t_rest#*|}"
                    $t_install
                    pause
                fi
                continue
            else
                return 0
            fi
        fi

        # Step 2: Show list of uninstalled tools and prompt comma-separated selection
        echo -e "\n  ${YELLOW}${BOLD}Select tools to install:${NC}"
        echo -e "  ${DIM}═════════════════════════════════════════════════════════════════${NC}"
        for u_idx in "${!uninstalled_names[@]}"; do
            local display_num=$((u_idx + 1))
            echo -e "  ${CYAN}[$display_num]${NC} ${BOLD}${uninstalled_names[$u_idx]}${NC}"
        done
        echo -e "  ${PURPLE}[A]${NC} ${BOLD}Install ALL uninstalled tools listed above${NC}"
        echo -e "  ${RED}[0]${NC} ${BOLD}Back to Main Menu${NC}"
        echo -e "  ${DIM}═════════════════════════════════════════════════════════════════${NC}"
        echo ""
        echo -e "  ${BOLD}Enter numbers separated by commas (e.g. 1,2 or 1,3 or 'A' or '0'):${NC}"
        echo -n "  > "
        read -r user_selection || return 0

        # Handle Back
        if [[ "$user_selection" =~ ^[0bBqQ]$ ]]; then
            return 0
        fi

        # Handle 'ALL'
        if [[ "$user_selection" =~ ^[Aa]$ ]]; then
            echo -e "\n${BOLD}${BLUE}==> Installing ALL ${#uninstalled_names[@]} missing tools...${NC}\n"
            for u_idx in "${!uninstalled_names[@]}"; do
                echo -e "\n${BOLD}${CYAN}-------------------------------------------------------${NC}"
                echo -e "${BOLD}Installing [$((u_idx+1))/${#uninstalled_names[@]}]: ${uninstalled_names[$u_idx]}${NC}"
                echo -e "${BOLD}${CYAN}-------------------------------------------------------${NC}"
                ${uninstalled_installers[$u_idx]}
            done
            sync_env
            persist_env
            echo -e "\n${GREEN}${BOLD}✓ Batch installation completed!${NC}"
            pause
            continue
        fi

        # Parse comma-separated numbers (e.g. "1, 2, 4" or "1,3")
        IFS=',' read -ra SELECTED_ITEMS <<< "$user_selection"
        local selected_count=0

        for sel in "${SELECTED_ITEMS[@]}"; do
            # Trim whitespace
            sel=$(echo "$sel" | xargs)
            if [[ "$sel" =~ ^[0-9]+$ ]]; then
                if [ "$sel" -ge 1 ] && [ "$sel" -le "${#uninstalled_names[@]}" ]; then
                    local target_u_idx=$((sel - 1))
                    echo -e "\n${BOLD}${CYAN}-------------------------------------------------------${NC}"
                    echo -e "${BOLD}Installing: ${uninstalled_names[$target_u_idx]}${NC}"
                    echo -e "${BOLD}${CYAN}-------------------------------------------------------${NC}"
                    ${uninstalled_installers[$target_u_idx]}
                    ((selected_count++))
                else
                    echo -e "${RED}Invalid selection number: $sel (skipped)${NC}"
                fi
            fi
        done

        if [ "$selected_count" -gt 0 ]; then
            sync_env
            persist_env
            echo -e "\n${GREEN}${BOLD}✓ Selected tool installation finished!${NC}"
            pause
        else
            echo -e "\n${YELLOW}No valid tools selected.${NC}"
            sleep 1.5
        fi
    done
}

# ==============================================================================
# TOOL ARRAYS PER CATEGORY
# Format: "Tool Display Name|check_function|install_function"
# ==============================================================================

TOOLS_ANDROID=(
    "Java 21 LTS (OpenJDK)|check_java21|install_java21"
    "Android Command-Line Tools (sdkmanager)|check_android_cmdline|install_android_cmdline"
    "Android Platform-Tools (adb, fastboot)|check_android_platform_tools|install_android_platform_tools"
    "Android SDK Platform (API 34 & 36)|check_android_platforms|install_android_platforms"
    "Android Build-Tools (28.0.3 & 34.0.0)|check_android_build_tools|install_android_build_tools"
    "Flutter SDK (Stable Channel)|check_flutter|install_flutter"
)

TOOLS_IOS=(
    "usbmuxd (USB daemon for iOS devices)|check_usbmuxd|install_usbmuxd"
    "libimobiledevice (iOS communication library)|check_libimobiledevice|install_libimobiledevice"
    "ideviceinstaller (App manager for iOS)|check_ideviceinstaller|install_ideviceinstaller"
    "CocoaPods (iOS Dependency Manager)|check_cocoapods|install_cocoapods"
)

TOOLS_WEB=(
    "Node.js (LTS) & npm Package Manager|check_nodejs|install_nodejs"
    "pnpm & yarn Package Managers|check_pnpm_yarn|install_pnpm_yarn"
    "PostgreSQL Database Client & Server|check_postgresql|install_postgresql"
    "Redis Server & In-Memory Store|check_redis|install_redis"
    "Docker Engine & Docker Compose|check_docker|install_docker"
    "Google Chrome / Chromium Browser|check_chrome|install_chrome"
)

TOOLS_AI=(
    "Python 3, pip, & venv Environment|check_python_env|install_python_env"
    "Ollama (Local LLM Runner - Llama 3, DeepSeek, Gemma)|check_ollama|install_ollama"
    "Core AI Stack (NumPy, Pandas, Scikit-Learn, PyTorch)|check_ai_stack|install_ai_stack"
    "JupyterLab & Notebook Web Interface|check_jupyter|install_jupyter"
    "Hugging Face Hub CLI (huggingface-cli)|check_huggingface|install_huggingface"
)

TOOLS_SOFTWARE=(
    "Visual Studio Code (VS Code)|check_vscode|install_vscode"
    "GitHub CLI (gh)|check_gh_cli|install_gh_cli"
    "Postman (API Testing Client)|check_postman|install_postman"
    "DBeaver Community (Universal Database GUI)|check_dbeaver|install_dbeaver"
    "Git GUI Tools (Git Cola / Gitk)|check_git_gui|install_git_gui"
    "Tmux & Htop (Terminal Productivity)|check_tmux_htop|install_tmux_htop"
)

TOOLS_CORE=(
    "Git CLI & Global Identity Setup|check_git_configured|install_git_configured"
    "GitHub SSH Authentication Key (~/.ssh/id_ed25519)|check_github_ssh|install_github_ssh"
    "C/C++ Build Essentials (clang, cmake, ninja, gtk-3)|check_build_essentials|install_build_essentials"
)

# ==============================================================================
# FULL SYSTEM SCANNER (ACROSS ALL FIELDS)
# ==============================================================================
full_scan_all() {
    draw_header
    echo -e "  ${BOLD}${BLUE}==> COMPREHENSIVE FULL SYSTEM DIAGNOSTIC SCAN${NC}\n"
    
    local categories=("TOOLS_ANDROID" "TOOLS_IOS" "TOOLS_WEB" "TOOLS_AI" "TOOLS_SOFTWARE" "TOOLS_CORE")
    local titles=("🤖 Android Development" "🍎 iOS Development (Linux)" "🌐 Web Development" "🧠 AI & Machine Learning" "💻 Development Software & IDEs" "🔧 Core System & Git")

    local total_checked=0
    local total_passed=0

    for c_idx in "${!categories[@]}"; do
        echo -e "  ${BOLD}${PURPLE}${titles[$c_idx]}${NC}"
        eval "local current_tools=(\"\${${categories[$c_idx]}[@]}\")"
        for t_item in "${current_tools[@]}"; do
            local name="${t_item%%|*}"
            local rest="${t_item#*|}"
            local check_fn="${rest%%|*}"
            ((total_checked++))
            if $check_fn; then
                badge_ok "$name"
                ((total_passed++))
            else
                badge_missing "$name"
            fi
        done
        echo ""
    done

    echo -e "  ${DIM}─────────────────────────────────────────────────────────────────${NC}"
    echo -e "  ${BOLD}Scan Summary:${NC} ${GREEN}$total_passed${NC} of ${BOLD}$total_checked${NC} tools installed across all categories."
    echo -e "  ${DIM}─────────────────────────────────────────────────────────────────${NC}"
    pause
}

# ==============================================================================
# MAIN MENU LOOP
# ==============================================================================
main_menu() {
    while true; do
        draw_header
        echo -e "  ${BOLD}Select a Development Field to Inspect & Install Tools:${NC}"
        echo ""
        echo -e "  ${CYAN}[1]${NC} ${BOLD}🤖 Android Development${NC}"
        echo -e "      ${DIM}Flutter, Java 21, cmdline-tools, SDK platforms 34/36, build-tools${NC}"
        echo ""
        echo -e "  ${CYAN}[2]${NC} ${BOLD}🍎 iOS Development (Linux Tools)${NC}"
        echo -e "      ${DIM}usbmuxd, libimobiledevice, ideviceinstaller, CocoaPods${NC}"
        echo ""
        echo -e "  ${CYAN}[3]${NC} ${BOLD}🌐 Web Development${NC}"
        echo -e "      ${DIM}Node.js, npm, pnpm, yarn, PostgreSQL, Redis, Docker, Chrome${NC}"
        echo ""
        echo -e "  ${CYAN}[4]${NC} ${BOLD}🧠 AI & Machine Learning Development${NC}"
        echo -e "      ${DIM}Python 3, Ollama (Local LLMs), PyTorch, NumPy, JupyterLab, Hugging Face${NC}"
        echo ""
        echo -e "  ${CYAN}[5]${NC} ${BOLD}💻 Development Softwares & IDEs${NC}"
        echo -e "      ${DIM}VS Code, GitHub CLI (gh), Postman, DBeaver, Git GUI, Tmux & Htop${NC}"
        echo ""
        echo -e "  ${CYAN}[6]${NC} ${BOLD}🔧 Core System Tools & Git / GitHub${NC}"
        echo -e "      ${DIM}Git Identity, GitHub SSH Key (~/.ssh/id_ed25519), C/C++ Build Essentials${NC}"
        echo ""
        echo -e "  ${PURPLE}[A]${NC} ${BOLD}🔍 Full System Diagnostic Scan (All Categories)${NC}"
        echo -e "  ${GREEN}[D]${NC} ${BOLD}🩺 Run Flutter Doctor Check${NC}"
        echo ""
        echo -e "  ${RED}[0]${NC} ${BOLD}🚪 Exit${NC}"
        echo ""
        echo -n "  Enter choice [0-6, A, D]: "
        read -r choice || exit 0

        case "$choice" in
            1) handle_category "🤖 Android Development" "TOOLS_ANDROID" ;;
            2) handle_category "🍎 iOS Development (Linux Tools)" "TOOLS_IOS" ;;
            3) handle_category "🌐 Web Development" "TOOLS_WEB" ;;
            4) handle_category "🧠 AI & Machine Learning Development" "TOOLS_AI" ;;
            5) handle_category "💻 Development Softwares & IDEs" "TOOLS_SOFTWARE" ;;
            6) handle_category "🔧 Core System Tools & Git / GitHub" "TOOLS_CORE" ;;
            [aA]) full_scan_all ;;
            [dD])
                draw_header
                echo -e "${BOLD}${BLUE}==> RUNNING FLUTTER DOCTOR...${NC}\n"
                sync_env
                if command -v flutter >/dev/null 2>&1; then
                    flutter doctor -v
                elif [ -x "$FLUTTER_DIR/bin/flutter" ]; then
                    "$FLUTTER_DIR/bin/flutter" doctor -v
                else
                    echo -e "${RED}Flutter is not installed yet. Go to Option [1] to install it.${NC}"
                fi
                pause
                ;;
            0|[qQ])
                echo -e "\n${GREEN}Thank you for using the Dev-Environment Manager! Happy coding!${NC}\n"
                exit 0
                ;;
            *)
                echo -e "\n${RED}Invalid option! Please enter a valid number or letter.${NC}"
                sleep 1
                ;;
        esac
    done
}

main_menu
