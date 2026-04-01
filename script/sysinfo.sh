#!/usr/bin/env bash
# sysinfo.sh - Lightweight System Information Tool
# Inspired by bench.sh but without network speed testing

# Color palette
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
RED='\033[38;5;203m'
GREEN='\033[38;5;114m'
YELLOW='\033[38;5;221m'
BLUE='\033[38;5;81m'
MAGENTA='\033[38;5;213m'
CYAN='\033[38;5;117m'
WHITE='\033[38;5;255m'

# Render helpers
print_kv() {
    local key="$1"
    local value="$2"
    printf "  ${CYAN}%-12s${RESET} %b\n" "${key}" "${value}"
}

print_divider() {
    printf "  ${DIM}────────────────────────────────────────────${RESET}\n"
}

# Get CPU information
get_cpu_info() {
    local cpu_model=""
    local cpu_cores=""
    local cpu_freq=""

    if [[ -f /proc/cpuinfo ]]; then
        cpu_model=$(awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//')
        cpu_cores=$(nproc 2>/dev/null || awk '/^processor/ {count++} END {print count+1}' /proc/cpuinfo)

        # Get CPU frequency in MHz
        if [[ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq ]]; then
            cpu_freq=$(($(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null) / 1000))
            cpu_freq="${cpu_freq} MHz"
        elif [[ -f /proc/cpuinfo ]]; then
            cpu_freq=$(awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//')
            if [[ -n "$cpu_freq" ]]; then
                cpu_freq="${cpu_freq} MHz"
            else
                cpu_freq="N/A"
            fi
        else
            cpu_freq="N/A"
        fi
    fi

    # Fallback for systems without /proc/cpuinfo
    if [[ -z "$cpu_model" ]]; then
        if command -v sysctl &> /dev/null; then
            cpu_model=$(sysctl -n machdep.cpu.brand_string 2>/dev/null)
            cpu_cores=$(sysctl -n hw.ncpu 2>/dev/null)
        fi
    fi

    print_kv "cpu" "${cpu_model:-Unknown}"
    print_kv "cores" "${cpu_cores:-N/A}"
    print_kv "freq" "${cpu_freq}"
}

# Get memory information
get_memory_info() {
    local mem_total=""
    local mem_used=""
    local mem_free=""
    local swap_total=""
    local swap_used=""

    if [[ -f /proc/meminfo ]]; then
        # Read values in KB
        mem_total=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
        mem_free=$(awk '/MemAvailable/ {print $2; exit} /MemFree/ {if(!f)print $2; f=1}' /proc/meminfo | head -1)
        swap_total=$(awk '/SwapTotal/ {print $2}' /proc/meminfo)
        local swap_free=$(awk '/SwapFree/ {print $2}' /proc/meminfo)

        # Calculate used memory
        mem_used=$((mem_total - mem_free))
        swap_used=$((swap_total - swap_free))

        # Convert to GB
        mem_total_gb=$(awk "BEGIN {printf \"%.2f\", $mem_total/1024/1024}")
        mem_used_gb=$(awk "BEGIN {printf \"%.2f\", $mem_used/1024/1024}")
        swap_total_gb=$(awk "BEGIN {printf \"%.2f\", $swap_total/1024/1024}")
        swap_used_gb=$(awk "BEGIN {printf \"%.2f\", $swap_used/1024/1024}")

        print_kv "memory" "${mem_used_gb} GB / ${mem_total_gb} GB"
        print_kv "swap" "${swap_used_gb} GB / ${swap_total_gb} GB"
    elif command -v sysctl &> /dev/null; then
        # macOS fallback
        local mem_pages mem_free_pages
        mem_pages=$(sysctl -n hw.memsize 2>/dev/null)
        mem_total=$(awk "BEGIN {printf \"%.2f\", $mem_pages/1024/1024/1024}")
        mem_free_pages=$(vm_stat | head -2 | tail -1 | awk '{print $3}' | sed 's/\.//')
        mem_used=$(awk "BEGIN {printf \"%.2f\", ($mem_pages/4096 - $mem_free_pages) * 4096 / 1024 / 1024 / 1024}")

        print_kv "memory" "${mem_used} GB / ${mem_total} GB"
        print_kv "swap" "N/A"
    else
        print_kv "memory" "N/A"
        print_kv "swap" "N/A"
    fi
}

# Get disk information
get_disk_info() {
    local disk_info=""

    if command -v df &> /dev/null; then
        disk_info=$(df -h -x squashfs -x tmpfs -x devtmpfs 2>/dev/null | awk 'NR>1 {used+=$3; total+=$2} END {if(total>0) printf "%.2f GB / %.2f GB", used/1024/1024, total/1024/1024; else print "N/A"}')
    fi

    print_kv "disk" "${disk_info}"
}

# Get OS information
get_os_info() {
    local os_name=""
    local kernel=""
    local arch=""

    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        os_name="$PRETTY_NAME"
    elif [[ -f /etc/redhat-release ]]; then
        os_name=$(cat /etc/redhat-release)
    elif [[ -f /etc/debian_version ]]; then
        os_name="Debian $(cat /etc/debian_version)"
    elif command -v sw_vers &> /dev/null; then
        os_name="$(sw_vers -productName) $(sw_vers -productVersion)"
    else
        os_name="Unknown"
    fi

    kernel=$(uname -r)
    arch=$(uname -m)

    print_kv "os" "${os_name}"
    print_kv "kernel" "${kernel}"
    print_kv "arch" "${arch}"
}

# Get uptime information
get_uptime_info() {
    local uptime_str=""

    if [[ -f /proc/uptime ]]; then
        local uptime_seconds=$(cat /proc/uptime | awk '{print int($1)}')
        local days=$((uptime_seconds / 86400))
        local hours=$(( (uptime_seconds % 86400) / 3600 ))
        local minutes=$(( (uptime_seconds % 3600) / 60 ))

        if [[ $days -gt 0 ]]; then
            uptime_str="${days} day(s), ${hours} hour(s), ${minutes} minute(s)"
        elif [[ $hours -gt 0 ]]; then
            uptime_str="${hours} hour(s), ${minutes} minute(s)"
        else
            uptime_str="${minutes} minute(s)"
        fi
    elif command -v uptime &> /dev/null; then
        uptime_str=$(uptime | awk -F'up ' '{print $2}' | awk -F', load' '{print $1}' | sed 's/^ *//g')
    else
        uptime_str="N/A"
    fi

    print_kv "uptime" "${uptime_str}"
}

# Get load average
get_load_info() {
    local load=""

    if [[ -f /proc/loadavg ]]; then
        load=$(awk '{print $1", "$2", "$3}' /proc/loadavg)
    elif command -v uptime &> /dev/null; then
        load=$(uptime | awk -F'load average: ' '{print $2}' | sed 's/, /, /g')
    else
        load="N/A"
    fi

    print_kv "load avg" "${load}"
}

# Get virtualization info
get_virt_info() {
    local virt=""

    if command -v systemd-detect-virt &> /dev/null; then
        virt=$(systemd-detect-virt 2>/dev/null)
        if [[ "$virt" == "none" ]]; then
            virt="None"
        else
            virt="${virt^}"
        fi
    elif [[ -d /proc/vz ]]; then
        virt="OpenVZ"
    elif [[ -d /proc/xen ]]; then
        virt="Xen"
    elif command -v dmidecode &> /dev/null; then
        if dmidecode -s system-product-name 2>/dev/null | grep -qi "vmware\|virtualbox\|qemu\|kvm"; then
            virt="VM"
        fi
    else
        virt="None"
    fi

    print_kv "virt" "${virt}"
}

# Check IPv4 connectivity
get_ipv4_status() {
    local status=""

    if ping -c 1 -W 2 1.1.1.1 &> /dev/null 2>&1 || ping -c 1 -W 2 8.8.8.8 &> /dev/null 2>&1; then
        status="${GREEN}Connected${RESET}"
    else
        status="${RED}Disconnected${RESET}"
    fi

    print_kv "ipv4" "${status}"
}

# Check IPv6 connectivity
get_ipv6_status() {
    local status=""

    if ping6 -c 1 -W 2 2606:4700:4700::1111 &> /dev/null 2>&1 || ping6 -c 1 -W 2 2001:4860:4860::8888 &> /dev/null 2>&1; then
        status="${GREEN}Connected${RESET}"
    else
        status="${RED}Disconnected${RESET}"
    fi

    print_kv "ipv6" "${status}"
}

print_modern_view() {
    local hostname user_name shell_name
    hostname=$(hostname 2>/dev/null || echo "unknown")
    user_name=$(whoami 2>/dev/null || echo "user")
    shell_name=$(basename "${SHELL:-bash}")

    clear
    echo -e "${BOLD}${MAGENTA}  ${user_name}@${hostname}${RESET}"
    print_divider

    local -a logo=(
        "       ${BLUE}___${RESET} "
        "    ${BLUE}.-\"   \"-.${RESET}"
        "   ${BLUE}/  .-. .- \\\\${RESET}"
        "  ${BLUE}|  /   Y   |${RESET}"
        "   ${BLUE}\\ \\ 0 | 0 /${RESET}"
        "    ${BLUE}'-\\_v_/-'${RESET}"
        "      ${BLUE} /   \\ ${RESET}"
        "      ${BLUE}/_/ \\_\\\\${RESET}"
    )

    local -a info=(
        "$(print_kv "tool" "${WHITE}sysinfo-tool${RESET}")"
        "$(print_kv "style" "neofetch-inspired")"
        "$(print_kv "shell" "${shell_name}")"
    )

    for i in "${!logo[@]}"; do
        if [[ $i -lt ${#info[@]} ]]; then
            printf "%b  %b\n" "${logo[$i]}" "${info[$i]}"
        else
            printf "%b\n" "${logo[$i]}"
        fi
    done

    print_divider
}

# Main function
main() {
    print_modern_view
    get_cpu_info
    print_divider
    get_memory_info
    print_divider
    get_disk_info
    print_divider
    get_os_info
    print_divider
    get_uptime_info
    get_load_info
    print_divider
    get_virt_info
    print_divider
    get_ipv4_status
    get_ipv6_status
    print_divider
    echo -e "  ${DIM}repo:${RESET} ${BLUE}https://github.com/oroliy/sysinfo-tool${RESET}"
    echo ""
}

# Run main
main "$@"
