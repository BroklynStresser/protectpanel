#!/bin/bash

# =============================================
# XNoctra Pterodactyl Protection System
# Author: XNoctra
# Telegram: t.me/XNoctra
# Version: 2.0
# =============================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Animation
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Banner
show_banner() {
    clear
    echo -e "${PURPLE}"
    echo " ██╗  ██╗███╗   ██╗ ██████╗ ██████╗████████╗██████╗  █████╗ "
    echo " ╚██╗██╔╝████╗  ██║██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗"
    echo "  ╚███╔╝ ██╔██╗ ██║██║   ██║██║        ██║   ██████╔╝███████║"
    echo "  ██╔██╗ ██║╚██╗██║██║   ██║██║        ██║   ██╔══██╗██╔══██║"
    echo " ██╔╝ ██╗██║ ╚████║╚██████╔╝╚██████╗   ██║   ██║  ██║██║  ██║"
    echo " ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝  ╚═════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝"
    echo -e "${NC}"
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              Pterodactyl Protection System v2.0          ║${NC}"
    echo -e "${CYAN}║                 Created by XNoctra                       ║${NC}"
    echo -e "${CYAN}║           Telegram: t.me/XNoctra                         ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Check Pterodactyl
check_pterodactyl() {
    echo -e "${YELLOW}🔍 Checking Pterodactyl installation...${NC}"
    
    if [ ! -d "/var/www/pterodactyl" ]; then
        echo -e "${RED}❌ Pterodactyl not found in /var/www/pterodactyl${NC}"
        exit 1
    fi
    
    if [ ! -f "/var/www/pterodactyl/artisan" ]; then
        echo -e "${RED}❌ Artisan file not found${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Pterodactyl detected${NC}"
}

# Check dependencies
check_dependencies() {
    echo -e "${YELLOW}📦 Checking dependencies...${NC}"
    
    local missing=()
    
    for cmd in curl php mysql; do
        if ! command -v $cmd &> /dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${YELLOW}⚠️ Installing missing dependencies: ${missing[*]}${NC}"
        sudo apt update
        sudo apt install -y "${missing[@]}"
    fi
    
    echo -e "${GREEN}✅ Dependencies satisfied${NC}"
}

# Download protection scripts
download_scripts() {
    echo -e "${YELLOW}📥 Downloading protection scripts...${NC}"
    
    BASE_URL="https://raw.githubusercontent.com/BroklynStresser/protectpanel/main"
    TEMP_DIR="/tmp/xnoctra-protections"
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR" || exit 1
    
    local scripts=(
        "installprotect1.sh" "installprotect2.sh" "installprotect3.sh"
        "installprotect4.sh" "installprotect5.sh" "installprotect6.sh"
        "installprotect7.sh" "installprotect8.sh" "installprotect9.sh"
        "uninstallprotect1.sh" "uninstallprotect2.sh" "uninstallprotect3.sh"
        "uninstallprotect4.sh" "uninstallprotect5.sh" "uninstallprotect6.sh"
        "uninstallprotect7.sh" "uninstallprotect8.sh" "uninstallprotect9.sh"
        "protect-manager.sh" "installprotectall.sh" "uninstallprotectall.sh"
    )
    
    for script in "${scripts[@]}"; do
        echo -e "${BLUE}📥 Downloading $script...${NC}"
        if curl -s -O "$BASE_URL/$script"; then
            chmod +x "$script"
            echo -e "${GREEN}✅ $script downloaded${NC}"
        else
            echo -e "${RED}❌ Failed to download $script${NC}"
            return 1
        fi
    done
    
    echo -e "${GREEN}✅ All scripts downloaded successfully${NC}"
    return 0
}

# (Fungsi lain sama seperti versi sebelumnya: show_main_menu, install_all, install_individual, uninstall_all, uninstall_individual, show_status, run_manager, update_scripts, system_info)

# Main function
main() {
    show_banner
    
    # Hapus check_root, langsung lanjut
    check_pterodactyl
    check_dependencies
    
    if ! download_scripts; then
        echo -e "${RED}❌ Failed to download protection scripts${NC}"
        exit 1
    fi
    
    while true; do
        show_main_menu
        read -p "Select option [0-8]: " choice
        
        case $choice in
            1) install_all ;;
            2) install_individual ;;
            3) uninstall_all ;;
            4) uninstall_individual ;;
            5) show_status ;;
            6) run_manager ;;
            7) update_scripts ;;
            8) system_info ;;
            0)
                echo -e "${GREEN}👋 Thank you for using XNoctra Protection System!${NC}"
                echo -e "${YELLOW}📞 Telegram: t.me/XNoctra${NC}"
                exit 0
                ;;
            *) echo -e "${RED}❌ Invalid option!${NC}" ;;
        esac
        
        echo
        read -p "Press Enter to continue..."
        show_banner
    done
}

main "$@"
