#!/bin/bash

# ============================================================
# Linux System Cleaner & Diagnostics
# Designed for Kali Linux / Debian-based systems
# ============================================================

set -u

# ---------- Colors ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ---------- Root check ----------
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}ERROR: This script must be run as administrator/root.${NC}"
    echo
    echo "Run it with:"
    echo "  sudo $0"
    exit 1
fi

# ---------- Header ----------
clear

echo -e "${CYAN}"
echo "============================================================"
echo "          LINUX SYSTEM CLEANER & DIAGNOSTICS"
echo "============================================================"
echo -e "${NC}"

echo "Hostname : $(hostname)"
echo "User     : ${SUDO_USER:-root}"
echo "Date     : $(date)"
echo "Kernel   : $(uname -r)"
echo

# ============================================================
# STORAGE BEFORE
# ============================================================

echo -e "${BLUE}================ STORAGE BEFORE ================${NC}"
df -h /
echo

# ============================================================
# MEMORY
# ============================================================

echo -e "${BLUE}================ MEMORY ================${NC}"
free -h
echo

# ============================================================
# CLEANING FUNCTIONS
# ============================================================

clean_tmp() {
    echo -e "${YELLOW}Cleaning temporary files...${NC}"

    # Remove contents of /tmp while preserving the directory itself
    find /tmp -mindepth 1 -maxdepth 1 -exec rm -rf -- {} + 2>/dev/null

    echo -e "${GREEN}Temporary files cleaned.${NC}"
    echo
}

clean_user_cache() {
    echo -e "${YELLOW}Cleaning user application cache...${NC}"

    if [[ -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
        USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

        if [[ -d "$USER_HOME/.cache" ]]; then
            find "$USER_HOME/.cache" -mindepth 1 -maxdepth 1 \
                -exec rm -rf -- {} + 2>/dev/null
        fi
    fi

    echo -e "${GREEN}User cache cleaned.${NC}"
    echo
}

clear_trash() {
    echo -e "${YELLOW}Clearing Trash...${NC}"

    if [[ -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
        USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

        TRASH="$USER_HOME/.local/share/Trash"

        if [[ -d "$TRASH" ]]; then
            rm -rf "$TRASH/files/"* 2>/dev/null
            rm -rf "$TRASH/info/"* 2>/dev/null
        fi
    fi

    # Also clean root's Trash if it exists
    if [[ -d /root/.local/share/Trash ]]; then
        rm -rf /root/.local/share/Trash/files/* 2>/dev/null
        rm -rf /root/.local/share/Trash/info/* 2>/dev/null
    fi

    echo -e "${GREEN}Trash cleared.${NC}"
    echo
}

clean_apt() {
    echo -e "${YELLOW}Cleaning APT package cache...${NC}"

    apt clean

    echo -e "${GREEN}APT cache cleaned.${NC}"
    echo

    read -rp "Remove unused packages with apt autoremove? [y/N]: " answer

    if [[ "$answer" =~ ^[Yy]$ ]]; then
        apt autoremove -y
    fi

    echo
}

clean_journal() {
    echo -e "${YELLOW}Checking system journal size...${NC}"

    journalctl --disk-usage

    echo

    read -rp "Limit system journals to 200 MB? [y/N]: " answer

    if [[ "$answer" =~ ^[Yy]$ ]]; then
        journalctl --vacuum-size=200M
    fi

    echo
}

# ============================================================
# DIAGNOSTICS
# ============================================================

system_diagnostics() {

    echo -e "${CYAN}"
    echo "============================================================"
    echo "                    SYSTEM DIAGNOSTICS"
    echo "============================================================"
    echo -e "${NC}"

    echo -e "${BLUE}--- OS INFORMATION ---${NC}"
    if command -v lsb_release >/dev/null 2>&1; then
        lsb_release -a 2>/dev/null
    else
        cat /etc/os-release
    fi
    echo

    echo -e "${BLUE}--- KERNEL ---${NC}"
    uname -a
    echo

    echo -e "${BLUE}--- UPTIME ---${NC}"
    uptime
    echo

    echo -e "${BLUE}--- CPU ---${NC}"
    lscpu | grep -E \
        'Model name|CPU\(s\)|Core|Thread|Architecture' | head -20
    echo

    echo -e "${BLUE}--- MEMORY ---${NC}"
    free -h
    echo

    echo -e "${BLUE}--- DISK USAGE ---${NC}"
    df -hT
    echo

    echo -e "${BLUE}--- BLOCK DEVICES ---${NC}"
    lsblk -o NAME,SIZE,TYPE,FSTYPE,LABEL,MOUNTPOINTS,MODEL
    echo

    echo -e "${BLUE}--- INODE USAGE ---${NC}"
    df -ih
    echo

    echo -e "${BLUE}--- FAILED SYSTEMD SERVICES ---${NC}"
    systemctl --failed --no-pager
    echo

    echo -e "${BLUE}--- RECENT BOOT ERRORS ---${NC}"
    journalctl -p 3 -b --no-pager -n 30
    echo

    echo -e "${BLUE}--- TOP LEVEL STORAGE USAGE ---${NC}"
    du -h --max-depth=1 / 2>/dev/null | sort -h
    echo

    echo -e "${BLUE}--- HOME STORAGE USAGE ---${NC}"

    if [[ -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
        USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
        du -h --max-depth=1 "$USER_HOME" 2>/dev/null | sort -h
    fi

    echo
}

# ============================================================
# LARGE FILE CHECK
# ============================================================

large_files() {

    echo -e "${CYAN}"
    echo "============================================================"
    echo "                  LARGE FILES (>1 GB)"
    echo "============================================================"
    echo -e "${NC}"

    find / \
        -xdev \
        -type f \
        -size +1G \
        -exec ls -lh {} \; \
        2>/dev/null

    echo
}

# ============================================================
# CLEANUP MENU
# ============================================================

cleanup_menu() {

    while true; do

        clear

        echo -e "${CYAN}"
        echo "============================================================"
        echo "                     CLEANUP MENU"
        echo "============================================================"
        echo -e "${NC}"

        echo "1) Clean /tmp"
        echo "2) Clean user cache"
        echo "3) Clear Trash"
        echo "4) Clean APT cache"
        echo "5) Clean system journals"
        echo "6) Run ALL safe cleanup operations"
        echo "7) Return to main menu"
        echo

        read -rp "Choose an option: " choice

        case "$choice" in

            1)
                clean_tmp
                read -rp "Press Enter to continue..."
                ;;

            2)
                clean_user_cache
                read -rp "Press Enter to continue..."
                ;;

            3)
                clear_trash
                read -rp "Press Enter to continue..."
                ;;

            4)
                clean_apt
                read -rp "Press Enter to continue..."
                ;;

            5)
                clean_journal
                read -rp "Press Enter to continue..."
                ;;

            6)
                echo
                echo -e "${YELLOW}This will clean temporary files, user cache,"
                echo "Trash, APT cache and optionally unused packages."
                echo

                read -rp "Continue? [y/N]: " confirm

                if [[ "$confirm" =~ ^[Yy]$ ]]; then
                    clean_tmp
                    clean_user_cache
                    clear_trash
                    clean_apt
                    clean_journal
                fi

                read -rp "Press Enter to continue..."
                ;;

            7)
                break
                ;;

            *)
                echo -e "${RED}Invalid option.${NC}"
                sleep 1
                ;;

        esac

    done
}

# ============================================================
# MAIN MENU
# ============================================================

while true; do

    clear

    echo -e "${CYAN}"
    echo "============================================================"
    echo "             LINUX CLEANER & DIAGNOSTICS"
    echo "============================================================"
    echo -e "${NC}"

    echo "1) Storage summary"
    echo "2) Cleanup menu"
    echo "3) Full system diagnostics"
    echo "4) Find files larger than 1 GB"
    echo "5) Run cleanup + diagnostics"
    echo "6) Exit"
    echo

    read -rp "Choose an option: " choice

    case "$choice" in

        1)
            echo
            echo -e "${BLUE}Storage:${NC}"
            df -h
            echo
            read -rp "Press Enter to continue..."
            ;;

        2)
            cleanup_menu
            ;;

        3)
            system_diagnostics
            read -rp "Press Enter to continue..."
            ;;

        4)
            large_files
            read -rp "Press Enter to continue..."
            ;;

        5)
            cleanup_menu
            system_diagnostics
            read -rp "Press Enter to continue..."
            ;;

        6)
            echo
            echo "Goodbye."
            exit 0
            ;;

        *)
            echo -e "${RED}Invalid option.${NC}"
            sleep 1
            ;;

    esac

done
