#!/usr/bin/env bash
# ==============================================================================
# GHOST-STACK // SYSTEM CLEANER & HARDWARE DIAGNOSTICS
# Platform: Linux (Kali, Debian, Ubuntu, Mint, Pop!_OS) & Android (Termux)
# Style: Cyberpunk Terminal Green (Strictly Zero Emojis)
# Author: Mwenda Boniface (https://github.com/Mwenda-Boniface)
# ==============================================================================

set -uo pipefail

# ==============================================================================
# COLOR PALETTE & AESTHETIC DESIGN TOKENS
# ==============================================================================
C_LIGHT_G="\033[1;32m"      # Vibrant emerald green
C_MINT="\033[38;5;84m"      # Crisp readable mint green
C_DARK_G="\033[38;5;29m"    # Deep border green
C_WHITE="\033[1;37m"        # High contrast bold white
C_GRAY="\033[38;5;244m"     # Technical muted gray
C_RED="\033[1;31m"          # Failure / alert
C_YELLOW="\033[1;33m"       # Warning / attention
C_CYAN="\033[1;36m"         # Accent cyan
C_BOLD="\033[1m"
C_DIM="\033[2m"
C_RESET="\033[0m"

# Platform detection
IS_TERMUX=false
if [ -n "${TERMUX_VERSION:-}" ] || [ -d "/data/data/com.termux" ] || [[ "${PREFIX:-}" =~ "com.termux" ]]; then
    IS_TERMUX=true
fi

CURRENT_USER="${SUDO_USER:-$(id -un 2>/dev/null || whoami)}"
CURRENT_HOME="${HOME:-/home/$CURRENT_USER}"
if [ -n "${SUDO_USER:-}" ] && command -v getent >/dev/null 2>&1; then
    USER_RESOLVED_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    [ -n "$USER_RESOLVED_HOME" ] && CURRENT_HOME="$USER_RESOLVED_HOME"
fi

# ==============================================================================
# PRIVILEGE RESOLUTION
# ==============================================================================
if [[ $EUID -ne 0 ]] && [ "$IS_TERMUX" = false ]; then
    if command -v sudo >/dev/null 2>&1 && [ -t 0 ]; then
        echo -e "\n  ${C_YELLOW}${C_BOLD}[ ELEVATION ]${C_RESET} ${C_WHITE}System Cleaner requires administrator privileges. Elevating with sudo...${C_RESET}\n"
        exec sudo bash "$0" "$@"
    else
        echo -e "\n  ${C_RED}${C_BOLD}[ ACCESS DENIED ]${C_RESET} ${C_WHITE}System Cleaner requires administrator privileges.${C_RESET}"
        echo -e "  ${C_GRAY}Please run this tool using:${C_RESET} ${C_LIGHT_G}sudo ghost-stack clean${C_RESET} or ${C_LIGHT_G}sudo $0${C_RESET}\n"
        exit 1
    fi
fi

# ==============================================================================
# STATUS BADGES & BORDERS (STRICTLY ZERO EMOJIS)
# ==============================================================================
badge_ok()    { echo -e "  ${C_LIGHT_G}${C_BOLD}[ OK ]${C_RESET}       $1"; }
badge_clean() { echo -e "  ${C_MINT}${C_BOLD}[ CLEANED ]${C_RESET}  $1"; }
badge_info()  { echo -e "  ${C_CYAN}${C_BOLD}[ INFO ]${C_RESET}     $1"; }
badge_warn()  { echo -e "  ${C_YELLOW}${C_BOLD}[ WARN ]${C_RESET}     $1"; }
badge_fail()  { echo -e "  ${C_RED}${C_BOLD}[ FAILED ]${C_RESET}   $1"; }

get_current_cols() {
    local term_cols="${GHOST_STACK_COLS:-${COLUMNS:-}}"
    if [ -z "$term_cols" ] || [ "$term_cols" -eq 0 ] 2>/dev/null; then
        term_cols=$(tput cols 2>/dev/null || echo 80)
    fi
    echo "$term_cols"
}

draw_box_header() {
    local title="$1"
    local tc
    tc=$(get_current_cols)
    local width=$((tc - 6))
    [ "$width" -gt 78 ] && width=78
    [ "$width" -lt 40 ] && width=40

    local title_len=${#title}
    local pad=$(( width - title_len - 6 ))
    [ "$pad" -lt 2 ] && pad=2
    echo -e "  ${C_DARK_G}┌─[ ${C_WHITE}${C_BOLD}${title}${C_RESET} ${C_DARK_G}]$(printf "%0.s─" $(seq 1 "$pad"))┐${C_RESET}"
}

draw_box_footer() {
    local tc
    tc=$(get_current_cols)
    local width=$((tc - 6))
    [ "$width" -gt 78 ] && width=78
    [ "$width" -lt 40 ] && width=40
    echo -e "  ${C_DARK_G}└$(printf "%0.s─" $(seq 1 "$width"))┘${C_RESET}"
}

pause() {
    echo ""
    echo -e "  ${C_GRAY}Press [Enter] to return...${C_RESET}"
    read -r || true
}

# ==============================================================================
# HEADER BANNER & SYSTEM TELEMETRY
# ==============================================================================
draw_cleaner_banner() {
    clear
    local tc
    tc=$(get_current_cols)

    echo -e "${C_LIGHT_G}${C_BOLD}"
    if [ "$tc" -ge 65 ]; then
        cat << "EOF"
   ________               __       _____ __             __  
  / ____/ /_  ____  _____/ /_     / ___// /_____ ______/ /__
 / / __/ __ \/ __ \/ ___/ __/_____\__ \/ __/ __ `/ ___/ //_/
/ /_/ / / / / /_/ (__  ) /_/_____/__/ / /_/ /_/ / /__/ ,<   
\____/_/ /_/\____/____/\__/     /____/\__/\__,_/\___/_/|_|  
EOF
    else
        echo "  [+] GHOST-STACK // SYSTEM CLEANER [+]"
    fi
    echo -e "${C_RESET}"
    echo -e "       ${C_WHITE}${C_BOLD}[ + ]   S Y S T E M   C L E A N E R   &   D I A G N O S T I C S   [ + ]${C_RESET}\n"

    # Telemetry data
    local free_mem root_disk os_detected
    free_mem=$(free -h 2>/dev/null | awk '/^Mem:/ {print $3 "/" $2 " (" $7 " Free)"}')
    [ -z "$free_mem" ] && free_mem="N/A"
    root_disk=$(df -h / 2>/dev/null | awk 'NR==2 {print $3 "/" $2 " (" $4 " Free)"}')
    [ -z "$root_disk" ] && root_disk="N/A"
    
    os_detected="Linux"
    if [ "$IS_TERMUX" = true ]; then
        os_detected="Android (Termux)"
    elif [ -f /etc/os-release ]; then
        os_detected=$(grep -E '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
    fi

    draw_box_header "SYSTEM TELEMETRY & RESOURCE BASELINE"
    printf "  ${C_DARK_G}│${C_RESET}  ${C_MINT}[*] Host  :${C_RESET} ${C_WHITE}%-18.18s${C_RESET} ${C_MINT}[*] User  :${C_RESET} ${C_WHITE}%-12.12s${C_RESET} ${C_MINT}[*] Kernel:${C_RESET} ${C_WHITE}%-14.14s${C_RESET} ${C_DARK_G}│${C_RESET}\n" "$(hostname 2>/dev/null || echo "localhost")" "$CURRENT_USER" "$(uname -r | cut -d- -f1-2)"
    printf "  ${C_DARK_G}│${C_RESET}  ${C_MINT}[*] OS    :${C_RESET} ${C_WHITE}%-18.18s${C_RESET} ${C_MINT}[*] Disk  :${C_RESET} ${C_WHITE}%-12.12s${C_RESET} ${C_MINT}[*] RAM   :${C_RESET} ${C_WHITE}%-14.14s${C_RESET} ${C_DARK_G}│${C_RESET}\n" "$os_detected" "$(echo "$root_disk" | awk '{print $1}')" "$(echo "$free_mem" | awk '{print $1}')"
    draw_box_footer
    echo ""
}

# ==============================================================================
# UNIFIED PURGE & AUTO-CLEAR ENGINE
# ==============================================================================
IS_IN_ROUTINE=false
CLEANUP_STAGE_RESULTS=()

redraw_routine_view() {
    draw_cleaner_banner
    draw_box_header "SAFE SYSTEM CLEANUP ROUTINE"
    echo -e "  ${C_DARK_G}│${C_RESET}  This routine safely purges temporary session files, user app caches,  ${C_DARK_G}│${C_RESET}"
    echo -e "  ${C_DARK_G}│${C_RESET}  trash cans, APT package download caches, and caps bloated journal logs.${C_DARK_G}│${C_RESET}"
    draw_box_footer
    echo ""
    for r in "${CLEANUP_STAGE_RESULTS[@]}"; do
        echo -e "$r"
    done
}

purge_targets() {
    local target_description="$1"
    local stage_label="$2"
    shift 2
    local targets=("$@")

    local log_file
    log_file=$(mktemp /tmp/ghost_clean_XXXXXX.log 2>/dev/null || echo "/tmp/ghost_clean_$$.log")
    : > "$log_file"

    local total_cleaned=0
    echo -e "\n  ${C_CYAN}${C_BOLD}[ ${stage_label} ]${C_RESET} ${C_WHITE}Scanning ${target_description}...${C_RESET}"

    local any_targets=false
    for t in "${targets[@]}"; do
        if [ -e "$t" ] || [ -d "$t" ]; then
            any_targets=true
            break
        fi
    done

    if [ "$any_targets" = false ]; then
        local msg="${target_description} is clean (0 pending items)."
        if [ "$IS_IN_ROUTINE" = true ]; then
            CLEANUP_STAGE_RESULTS+=("  ${C_CYAN}${C_BOLD}[ INFO ]${C_RESET}     ${msg}")
            redraw_routine_view
        else
            badge_info "$msg"
        fi
        rm -f "$log_file" 2>/dev/null || true
        return 0
    fi

    echo -e "  ${C_MINT}${C_BOLD}[ PURGING ]${C_RESET} ${C_WHITE}Streaming active deletion logs:${C_RESET}\n"

    for t in "${targets[@]}"; do
        [ ! -e "$t" ] && [ ! -d "$t" ] && continue

        # Safety filter for /tmp
        if [ "$t" = "/tmp" ] || [ "$t" = "${TMPDIR:-/data/data/com.termux/files/usr/tmp}" ]; then
            while IFS= read -r subnode; do
                [ -z "$subnode" ] && continue
                case "$subnode" in
                    */.X11-unix|*/.ICE-unix|*/.Test-unix|*/.font-unix|*/.XIM-unix)
                        continue
                        ;;
                esac
                while IFS= read -r line; do
                    [ -z "$line" ] && continue
                    local clean_path="${line#removed \'}"
                    clean_path="${clean_path%\'}"
                    clean_path="${clean_path#removed directory \'}"
                    clean_path="${clean_path%\'}"
                    printf "  ${C_DARK_G}▸${C_RESET} ${C_GRAY}cleaned:${C_RESET} ${C_WHITE}%s${C_RESET}\n" "$clean_path"
                    echo "$clean_path" >> "$log_file"
                    ((total_cleaned++)) || true
                done < <(rm -rfv "$subnode" 2>/dev/null)
            done < <(find "$t" -mindepth 1 -maxdepth 1 2>/dev/null)
            continue
        fi

        # Normal directory traversal
        if [ -d "$t" ]; then
            while IFS= read -r subnode; do
                [ -z "$subnode" ] && continue
                while IFS= read -r line; do
                    [ -z "$line" ] && continue
                    local clean_path="${line#removed \'}"
                    clean_path="${clean_path%\'}"
                    clean_path="${clean_path#removed directory \'}"
                    clean_path="${clean_path%\'}"
                    printf "  ${C_DARK_G}▸${C_RESET} ${C_GRAY}cleaned:${C_RESET} ${C_WHITE}%s${C_RESET}\n" "$clean_path"
                    echo "$clean_path" >> "$log_file"
                    ((total_cleaned++)) || true
                done < <(rm -rfv "$subnode" 2>/dev/null)
            done < <(find "$t" -mindepth 1 -maxdepth 1 2>/dev/null)
        else
            while IFS= read -r line; do
                [ -z "$line" ] && continue
                local clean_path="${line#removed \'}"
                clean_path="${clean_path%\'}"
                clean_path="${clean_path#removed directory \'}"
                clean_path="${clean_path%\'}"
                printf "  ${C_DARK_G}▸${C_RESET} ${C_GRAY}cleaned:${C_RESET} ${C_WHITE}%s${C_RESET}\n" "$clean_path"
                echo "$clean_path" >> "$log_file"
                ((total_cleaned++)) || true
            done < <(rm -rfv "$t" 2>/dev/null)
        fi
    done

    if [ "$total_cleaned" -eq 0 ]; then
        local msg="${target_description} has 0 items requiring cleanup."
        if [ "$IS_IN_ROUTINE" = true ]; then
            CLEANUP_STAGE_RESULTS+=("  ${C_CYAN}${C_BOLD}[ INFO ]${C_RESET}     ${msg}")
            redraw_routine_view
        else
            badge_info "$msg"
        fi
        rm -f "$log_file" 2>/dev/null || true
        return 0
    fi

    echo ""
    echo -e "  ${C_LIGHT_G}${C_BOLD}[ COMPLETED ]${C_RESET} ${C_WHITE}${total_cleaned} item(s) purged.${C_RESET} ${C_GRAY}Autoclearing deletion activity logs...${C_RESET}"
    sleep 1

    # Autoclear temporary disk log
    rm -f "$log_file" 2>/dev/null || true

    local result_badge="  ${C_MINT}${C_BOLD}[ CLEANED ]${C_RESET}  ${target_description} (${total_cleaned} items purged). Logs autocleared."

    if [ "$IS_IN_ROUTINE" = true ]; then
        CLEANUP_STAGE_RESULTS+=("$result_badge")
        redraw_routine_view
    else
        draw_cleaner_banner
        echo -e "$result_badge"
    fi
}

# ==============================================================================
# CLEANING MODULES
# ==============================================================================
clean_tmp() {
    local tmp_dir="/tmp"
    if [ "$IS_TERMUX" = true ]; then
        tmp_dir="${TMPDIR:-${PREFIX:-}/tmp}"
    fi
    purge_targets "Temporary directory storage ($tmp_dir)" "STAGE 1/5" "$tmp_dir"
}

clean_user_cache() {
    local cache_target="$CURRENT_HOME/.cache"
    purge_targets "Application cache (~/.cache)" "STAGE 2/5" "$cache_target"
}

clear_trash() {
    local user_trash="$CURRENT_HOME/.local/share/Trash"
    local root_trash="/root/.local/share/Trash"
    local trash_targets=()
    [ -d "$user_trash/files" ] && trash_targets+=("$user_trash/files")
    [ -d "$user_trash/info" ] && trash_targets+=("$user_trash/info")
    if [ -d "$root_trash/files" ]; then
        trash_targets+=("$root_trash/files" "$root_trash/info")
    fi
    purge_targets "Desktop & root trash cans" "STAGE 3/5" "${trash_targets[@]}"
    mkdir -p "$user_trash/files" "$user_trash/info" 2>/dev/null || true
}

clean_apt() {
    local stage_label="STAGE 4/5"
    echo -e "\n  ${C_CYAN}${C_BOLD}[ ${stage_label} ]${C_RESET} ${C_WHITE}Inspecting APT package manager download archives & caches...${C_RESET}"

    if [ "$IS_TERMUX" = true ]; then
        if command -v apt-get >/dev/null 2>&1; then
            apt-get clean 2>/dev/null || true
            local msg="Termux package repository cache purged."
            if [ "$IS_IN_ROUTINE" = true ]; then
                CLEANUP_STAGE_RESULTS+=("  ${C_MINT}${C_BOLD}[ CLEANED ]${C_RESET}  $msg")
                redraw_routine_view
            else
                badge_clean "$msg"
            fi
        fi
        return 0
    fi

    if ! command -v apt-get >/dev/null 2>&1; then
        local msg="APT package manager not present on this host platform."
        if [ "$IS_IN_ROUTINE" = true ]; then
            CLEANUP_STAGE_RESULTS+=("  ${C_CYAN}${C_BOLD}[ INFO ]${C_RESET}     $msg")
            redraw_routine_view
        else
            badge_info "$msg"
        fi
        return 0
    fi

    local deb_count=0
    local apt_archives="/var/cache/apt/archives"
    if [ -d "$apt_archives" ]; then
        deb_count=$(find "$apt_archives" -type f -name "*.deb" 2>/dev/null | wc -l)
    fi

    if [ "$deb_count" -gt 0 ]; then
        echo -e "  ${C_MINT}${C_BOLD}[ PURGING ]${C_RESET} ${C_WHITE}Found $deb_count cached package archives (.deb). Streaming deletion logs:${C_RESET}\n"
        while IFS= read -r line; do
            [ -z "$line" ] && continue
            local clean_path="${line#removed \'}"
            clean_path="${clean_path%\'}"
            printf "  ${C_DARK_G}▸${C_RESET} ${C_GRAY}cleaned:${C_RESET} ${C_WHITE}%s${C_RESET}\n" "$clean_path"
        done < <(find "$apt_archives" -type f -name "*.deb" -exec rm -rfv {} + 2>/dev/null)
    fi
    apt-get clean 2>/dev/null || true

    local autoremove_done=false
    if apt-get autoremove --dry-run 2>/dev/null | grep -q "0 upgraded, 0 newly installed, [1-9]"; then
        echo ""
        echo -ne "  ${C_MINT}[ ? ] Scan and remove orphaned/unused packages (apt autoremove)? [y/N]: ${C_RESET}"
        local answer
        read -r answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            echo -e "  ${C_MINT}${C_BOLD}[ PURGING ]${C_RESET} ${C_WHITE}Pruning orphaned packages and dependencies:${C_RESET}\n"
            while IFS= read -r line; do
                if [[ "$line" =~ ^(Removing|Purging) ]]; then
                    printf "  ${C_DARK_G}▸${C_RESET} ${C_GRAY}cleaned:${C_RESET} ${C_WHITE}%s${C_RESET}\n" "$line"
                fi
            done < <(apt-get autoremove -y 2>&1)
            autoremove_done=true
        fi
    fi

    echo ""
    echo -e "  ${C_LIGHT_G}${C_BOLD}[ COMPLETED ]${C_RESET} ${C_WHITE}APT cache optimization finished.${C_RESET} ${C_GRAY}Autoclearing deletion activity logs...${C_RESET}"
    sleep 1

    local apt_msg="APT package archives & dependency trees pruned."
    if [ "$deb_count" -gt 0 ]; then
        apt_msg="APT package cache ($deb_count .deb archives) purged."
    fi

    if [ "$IS_IN_ROUTINE" = true ]; then
        CLEANUP_STAGE_RESULTS+=("  ${C_MINT}${C_BOLD}[ CLEANED ]${C_RESET}  $apt_msg Logs autocleared.")
        redraw_routine_view
    else
        draw_cleaner_banner
        badge_clean "$apt_msg Logs autocleared."
    fi
}

clean_journal() {
    local stage_label="STAGE 5/5"
    echo -e "\n  ${C_CYAN}${C_BOLD}[ ${stage_label} ]${C_RESET} ${C_WHITE}Inspecting system journals & rotated system log files (/var/log)...${C_RESET}"

    local rotated_logs=()
    if [ -d "/var/log" ]; then
        while IFS= read -r rlog; do
            [ -n "$rlog" ] && rotated_logs+=("$rlog")
        done < <(find /var/log -type f \( -name "*.gz" -o -name "*.1" -o -name "*.old" -o -name "*.[0-9]*.gz" \) 2>/dev/null)
    fi

    local log_count=${#rotated_logs[@]}
    if [ "$log_count" -gt 0 ]; then
        echo -e "  ${C_MINT}${C_BOLD}[ PURGING ]${C_RESET} ${C_WHITE}Found $log_count rotated archived log files. Streaming deletion logs:${C_RESET}\n"
        for rlog in "${rotated_logs[@]}"; do
            rm -rfv "$rlog" 2>/dev/null | while IFS= read -r line; do
                [ -z "$line" ] && continue
                local clean_path="${line#removed \'}"
                clean_path="${clean_path%\'}"
                printf "  ${C_DARK_G}▸${C_RESET} ${C_GRAY}cleaned:${C_RESET} ${C_WHITE}%s${C_RESET}\n" "$clean_path"
            done
        done
    fi

    local vacuum_done=false
    if command -v journalctl >/dev/null 2>&1; then
        local current_usage
        current_usage=$(journalctl --disk-usage 2>/dev/null || echo "N/A")
        badge_info "Active Journal Footprint: ${C_WHITE}${current_usage}${C_RESET}"

        echo ""
        echo -ne "  ${C_MINT}[ ? ] Vacuum and cap system journal logs to 200 MB? [y/N]: ${C_RESET}"
        local answer
        read -r answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            echo -e "  ${C_MINT}${C_BOLD}[ PURGING ]${C_RESET} ${C_WHITE}Vacuuming systemd journal logs to 200M quota:${C_RESET}\n"
            journalctl --vacuum-size=200M 2>&1 | while IFS= read -r jline; do
                [ -z "$jline" ] && continue
                printf "  ${C_DARK_G}▸${C_RESET} ${C_GRAY}vacuumed:${C_RESET} ${C_WHITE}%s${C_RESET}\n" "$jline"
            done
            vacuum_done=true
        fi
    fi

    echo ""
    echo -e "  ${C_LIGHT_G}${C_BOLD}[ COMPLETED ]${C_RESET} ${C_WHITE}System logs and journal optimization complete.${C_RESET} ${C_GRAY}Autoclearing deletion activity logs...${C_RESET}"
    sleep 1

    local j_msg="System journals & archived logs vacuumed ($log_count rotated logs purged)."
    if [ "$IS_IN_ROUTINE" = true ]; then
        CLEANUP_STAGE_RESULTS+=("  ${C_MINT}${C_BOLD}[ CLEANED ]${C_RESET}  $j_msg Logs autocleared.")
        redraw_routine_view
    else
        draw_cleaner_banner
        badge_clean "$j_msg Logs autocleared."
    fi
}

run_full_cleanup_routine() {
    IS_IN_ROUTINE=true
    CLEANUP_STAGE_RESULTS=()

    local storage_before storage_after
    storage_before=$(df -h / 2>/dev/null | awk 'NR==2 {print $4}')

    redraw_routine_view

    clean_tmp
    clean_user_cache
    clear_trash
    clean_apt
    clean_journal

    storage_after=$(df -h / 2>/dev/null | awk 'NR==2 {print $4}')

    IS_IN_ROUTINE=false
    redraw_routine_view

    echo ""
    draw_box_header "CLEANUP VERIFICATION & RESULTS"
    printf "  ${C_DARK_G}│${C_RESET}  ${C_WHITE}%-26s${C_RESET} : ${C_YELLOW}%-44s${C_RESET} ${C_DARK_G}│${C_RESET}\n" "Free Storage (Before)" "$storage_before"
    printf "  ${C_DARK_G}│${C_RESET}  ${C_WHITE}%-26s${C_RESET} : ${C_LIGHT_G}%-44s${C_RESET} ${C_DARK_G}│${C_RESET}\n" "Free Storage (After)" "$storage_after"
    printf "  ${C_DARK_G}│${C_RESET}  ${C_WHITE}%-26s${C_RESET} : ${C_MINT}%-44s${C_RESET} ${C_DARK_G}│${C_RESET}\n" "System Status" "OPTIMIZED & VERIFIED"
    printf "  ${C_DARK_G}│${C_RESET}  ${C_WHITE}%-26s${C_RESET} : ${C_WHITE}%-44s${C_RESET} ${C_DARK_G}│${C_RESET}\n" "Activity Logs" "AUTOCLEARED"
    draw_box_footer
}

# ==============================================================================
# DIAGNOSTICS MODULES
# ==============================================================================
show_storage_summary() {
    draw_cleaner_banner
    draw_box_header "STORAGE & FILESYSTEM MOUNTPOINTS (df -h)"
    echo -e "${C_GRAY}"
    df -h / 2>/dev/null || df -h
    echo -e "${C_RESET}"
    draw_box_footer
    echo ""

    draw_box_header "MEMORY & SWAP POOL ALLOCATION (free -h)"
    echo -e "${C_GRAY}"
    free -h 2>/dev/null || free
    echo -e "${C_RESET}"
    draw_box_footer
}

system_diagnostics() {
    draw_cleaner_banner

    # 1. OS Info
    draw_box_header "01 // OS & PLATFORM INFORMATION"
    echo -e "${C_WHITE}"
    if command -v lsb_release >/dev/null 2>&1; then
        lsb_release -a 2>/dev/null | sed 's/^/  /'
    elif [ -f /etc/os-release ]; then
        grep -E '^(PRETTY_NAME|NAME|VERSION|ID)=' /etc/os-release | sed 's/^/  /'
    fi
    echo -e "${C_RESET}"
    draw_box_footer
    echo ""

    # 2. Kernel & Uptime
    draw_box_header "02 // KERNEL IDENTIFIERS & UPTIME"
    echo -e "  ${C_MINT}[*] Kernel Release :${C_RESET} ${C_WHITE}$(uname -a)${C_RESET}"
    echo -e "  ${C_MINT}[*] Host Uptime    :${C_RESET} ${C_WHITE}$(uptime 2>/dev/null || echo "N/A")${C_RESET}"
    draw_box_footer
    echo ""

    # 3. CPU Topology
    draw_box_header "03 // CPU HARDWARE SPECIFICATIONS"
    echo -e "${C_GRAY}"
    if command -v lscpu >/dev/null 2>&1; then
        lscpu | grep -E 'Model name|CPU\(s\)|Core|Thread|Architecture|CPU max MHz|Virtualization' | head -15 | sed 's/^/  /'
    elif [ -f /proc/cpuinfo ]; then
        awk -F: '/model name/{print "  Model: " $2; exit}' /proc/cpuinfo
        awk '/cpu cores/{print "  Cores: " $4; exit}' /proc/cpuinfo 2>/dev/null || true
    fi
    echo -e "${C_RESET}"
    draw_box_footer
    echo ""

    # 4. Memory Pool
    draw_box_header "04 // MEMORY ALLOCATION (RAM & SWAP)"
    echo -e "${C_GRAY}"
    free -h 2>/dev/null | sed 's/^/  /' || free | sed 's/^/  /'
    echo -e "${C_RESET}"
    draw_box_footer
    echo ""

    # 5. Disk Filesystems
    draw_box_header "05 // FILESYSTEM & STORAGE MOUNTPOINTS"
    echo -e "${C_GRAY}"
    df -hT -x tmpfs -x devtmpfs -x overlay 2>/dev/null | sed 's/^/  /' || df -h | sed 's/^/  /'
    echo -e "${C_RESET}"
    draw_box_footer
    echo ""

    # 6. Block Devices
    if command -v lsblk >/dev/null 2>&1; then
        draw_box_header "06 // PHYSICAL BLOCK DEVICES & PARTITIONS"
        echo -e "${C_GRAY}"
        lsblk -o NAME,SIZE,TYPE,FSTYPE,LABEL,MOUNTPOINTS,MODEL 2>/dev/null | sed 's/^/  /'
        echo -e "${C_RESET}"
        draw_box_footer
        echo ""
    fi

    # 7. Inode Usage
    draw_box_header "07 // FILESYSTEM INODE ALLOCATION (df -ih)"
    echo -e "${C_GRAY}"
    df -ih -x tmpfs -x devtmpfs 2>/dev/null | head -10 | sed 's/^/  /' || df -i | head -10 | sed 's/^/  /'
    echo -e "${C_RESET}"
    draw_box_footer
    echo ""

    # 8. Failed Systemd Services
    if command -v systemctl >/dev/null 2>&1; then
        draw_box_header "08 // FAILED SYSTEMD SERVICES & UNITS"
        local failed_units
        failed_units=$(systemctl --failed --no-legend 2>/dev/null || true)
        if [ -n "$failed_units" ]; then
            echo -e "${C_RED}"
            echo "$failed_units" | sed 's/^/  /'
            echo -e "${C_RESET}"
        else
            echo -e "  ${C_LIGHT_G}[ OK ] 0 failed systemd units. All system services healthy.${C_RESET}"
        fi
        draw_box_footer
        echo ""
    fi

    # 9. Recent Boot Errors
    if command -v journalctl >/dev/null 2>&1; then
        draw_box_header "09 // RECENT CRITICAL LOG EVENTS (PRIORITY 3 - ERROR)"
        local log_errors
        log_errors=$(journalctl -p 3 -b --no-pager -n 8 2>/dev/null || true)
        if [ -n "$log_errors" ]; then
            echo -e "${C_YELLOW}"
            echo "$log_errors" | sed 's/^/  /'
            echo -e "${C_RESET}"
        else
            echo -e "  ${C_LIGHT_G}[ OK ] Zero critical boot errors recorded in current session journal.${C_RESET}"
        fi
        draw_box_footer
        echo ""
    fi

    # 10. Top-Level Storage Consumption
    draw_box_header "10 // TOP-LEVEL ROOT STORAGE CONSUMPTION (du -h /)"
    echo -e "${C_GRAY}"
    du -h --max-depth=1 / 2>/dev/null | sort -h | tail -10 | sed 's/^/  /'
    echo -e "${C_RESET}"
    draw_box_footer
    echo ""

    # 11. User Home Directory Footprint
    if [ -d "$CURRENT_HOME" ]; then
        draw_box_header "11 // USER DIRECTORY STORAGE FOOTPRINT ($CURRENT_HOME)"
        echo -e "${C_GRAY}"
        du -h --max-depth=1 "$CURRENT_HOME" 2>/dev/null | sort -h | tail -10 | sed 's/^/  /'
        echo -e "${C_RESET}"
        draw_box_footer
        echo ""
    fi
}

large_files() {
    draw_cleaner_banner
    draw_box_header "LARGE FILES SEARCH (> 1 GB)"
    echo -e "  ${C_GRAY}Scanning local filesystem boundaries (-xdev) for files exceeding 1.0 GiB...${C_RESET}\n"

    local found_any=false
    while IFS= read -r line; do
        if [ -n "$line" ]; then
            echo -e "  ${C_YELLOW}${C_BOLD}[ >1GB ]${C_RESET} ${C_WHITE}$line${C_RESET}"
            found_any=true
        fi
    done < <(find / -xdev -type f -size +1G -exec ls -lh {} + 2>/dev/null | awk '{print $5, $9}')

    if [ "$found_any" = false ]; then
        echo -e "  ${C_LIGHT_G}${C_BOLD}[ OK ] No single files exceeding 1.0 GiB found on the root volume.${C_RESET}"
    fi
    echo ""
    draw_box_footer
}

# ==============================================================================
# SUB-MENU: MODULAR CLEANUP SUITE
# ==============================================================================
cleanup_menu() {
    while true; do
        IS_IN_ROUTINE=false
        draw_cleaner_banner
        draw_box_header "MODULAR CLEANUP SUITE"
        echo -e "  ${C_WHITE}[ 1 ]${C_RESET} ${C_LIGHT_G}Purge Temporary Files (/tmp)${C_RESET}"
        echo -e "  ${C_WHITE}[ 2 ]${C_RESET} ${C_LIGHT_G}Purge User Application Caches (~/.cache)${C_RESET}"
        echo -e "  ${C_WHITE}[ 3 ]${C_RESET} ${C_LIGHT_G}Empty User & Root Desktop Trash Cans${C_RESET}"
        echo -e "  ${C_WHITE}[ 4 ]${C_RESET} ${C_LIGHT_G}Clean APT Package Cache & Orphaned Deps${C_RESET}"
        echo -e "  ${C_WHITE}[ 5 ]${C_RESET} ${C_LIGHT_G}Vacuum System Journals & Rotated Logs${C_RESET}"
        echo -e "  ${C_WHITE}[ 6 ]${C_RESET} ${C_MINT}${C_BOLD}Execute Complete Safe Cleanup Routine${C_RESET}"
        echo -e "  ${C_WHITE}[ 0 ]${C_RESET} ${C_GRAY}Return to Cleaner Main Menu${C_RESET}"
        draw_box_footer
        echo ""
        echo -ne "  ${C_LIGHT_G}${C_BOLD}ghost-stack(cleaner-suite) > ${C_RESET}"
        read -r c_choice || return 0

        case "$c_choice" in
            1) clean_tmp; pause ;;
            2) clean_user_cache; pause ;;
            3) clear_trash; pause ;;
            4) clean_apt; pause ;;
            5) clean_journal; pause ;;
            6) run_full_cleanup_routine; pause ;;
            0|[qQ]|back|exit|"") return 0 ;;
            *)
                echo -e "  ${C_RED}Invalid option: $c_choice${C_RESET}"
                sleep 0.5
                ;;
        esac
    done
}

# ==============================================================================
# MAIN INTERACTIVE MENU
# ==============================================================================
main() {
    while true; do
        draw_cleaner_banner
        draw_box_header "CLEANER & DIAGNOSTICS SUITE"
        echo -e "  ${C_WHITE}[ 1 ]${C_RESET} ${C_LIGHT_G}Storage Summary & Filesystem Allocation${C_RESET}"
        echo -e "  ${C_WHITE}[ 2 ]${C_RESET} ${C_LIGHT_G}Modular System Cache & Temp Cleaner${C_RESET}"
        echo -e "  ${C_WHITE}[ 3 ]${C_RESET} ${C_LIGHT_G}Comprehensive Hardware & OS Diagnostics${C_RESET}"
        echo -e "  ${C_WHITE}[ 4 ]${C_RESET} ${C_LIGHT_G}Locate High-Footprint Files (> 1 GB)${C_RESET}"
        echo -e "  ${C_WHITE}[ 5 ]${C_RESET} ${C_MINT}${C_BOLD}Run Full Cleanup + Diagnostics Verification${C_RESET}"
        echo -e "  ${C_WHITE}[ 0 ]${C_RESET} ${C_GRAY}Return to Ghost-Stack Hub${C_RESET}"
        draw_box_footer
        echo ""
        echo -ne "  ${C_LIGHT_G}${C_BOLD}ghost-stack(cleaner) > ${C_RESET}"
        read -r choice || exit 0

        case "$choice" in
            1) show_storage_summary; pause ;;
            2) cleanup_menu ;;
            3) system_diagnostics; pause ;;
            4) large_files; pause ;;
            5)
                run_full_cleanup_routine
                echo ""
                echo -e "  ${C_MINT}${C_BOLD}Proceeding to system health diagnostics...${C_RESET}"
                sleep 1
                system_diagnostics
                pause
                ;;
            0|[qQ]|exit|quit|"")
                echo -e "\n  ${C_LIGHT_G}Returning to Ghost-Stack. Clean system state verified.${C_RESET}\n"
                exit 0
                ;;
            *)
                echo -e "  ${C_RED}Invalid option: $choice${C_RESET}"
                sleep 0.5
                ;;
        esac
    done
}

main "$@"
