#!/bin/bash

# Warna teks
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
DARK_GREEN='\033[0;32m'
LIGHT_GREEN='\033[1;32m'
BOLD='\033[1m'
RESET='\033[0m'

# Fungsi untuk animasi awal
show_animation() {
    clear
    echo -e "${CYAN}${BOLD}======================================="
    echo -e "          Auto Install Theme Premium           "
    echo -e "                 by ikystore 3.3            "
    echo -e "=======================================${RESET}"
    sleep 0.5
    echo ""
  echo -e "${GREEN}Hubungi kami: ${BOLD}wa.me/6285878836361 (ikystore)${RESET}"
    sleep 0.5
    echo ""
    echo -e "${YELLOW}>> Loading...${RESET}"
    sleep 0.5
    echo -e "${GREEN}>> Preparing the script...${RESET}"
    sleep 0.5
    echo -e "${BLUE}>> Ready to go!${RESET}"
    sleep 1
}
# Fungsi animasi keluar
show_closing_animation() {
    clear
    echo -e "${CYAN}${BOLD}======================================="
    echo -e "              Closing...              "
    echo -e "=======================================${RESET}"
    sleep 0.5
    echo -e "${GREEN}Terima kasih telah menggunakan script ini.${RESET}"
    sleep 1
    echo -e "${YELLOW}© ikystore${RESET}"
    sleep 1
    echo -e "${BLUE}See you next time!${RESET}"
    sleep 1
}
# Fungsi untuk menginstal Node.js dan dependensi dasar
install_node() {
    echo -e "${CYAN}>> INSTALL NODE 20 DAN KEY <<${RESET}"
    sudo apt-get install -y ca-certificates curl gnupg
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    sudo apt-get update
    sudo apt-get install -y nodejs
    echo -e "${GREEN}Node.js dan dependensi dasar telah berhasil diinstal.${RESET}"
}

# Fungsi untuk menginstal Blueprint.zip base
install_blueprint() {
    echo -e "${CYAN}>> INSTALL BLUEPRINT.ZIP BASE <<${RESET}"
    
    cd /var/www/pterodactyl
    npm i -g yarn
    yarn
    yarn add cross-env
    sudo apt install -y zip unzip git curl wget
    wget "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | cut -d '"' -f 4)" -O release.zip
    sudo unzip release.zip
    FOLDER="/var/www/pterodactyl"
    WEBUSER="www-data"
    USERSHELL="/bin/bash"
    PERMISSIONS="www-data:www-data"
    sudo sed -i -E -e "s|WEBUSER=\"www-data\" #;|WEBUSER=\"$WEBUSER\" #;|g" \
    -e "s|USERSHELL=\"/bin/bash\" #;|USERSHELL=\"$USERSHELL\" #;|g" \
    -e "s|OWNERSHIP=\"www-data:www-data\" #;|OWNERSHIP=\"$PERMISSIONS\" #;|g" $FOLDER/blueprint.sh
    sudo chmod +x blueprint.sh
    sudo bash blueprint.sh
    echo -e "${GREEN}Blueprint berhasil diinstal.${RESET}"
}

# Fungsi untuk menginstal theme berdasarkan nama
install_theme() {
    echo -e "${CYAN}>> PROSES DOWNLOAD DAN INSTAL THEME <<${RESET}"
    THEME_NAME=$1
    if [ -z "$THEME_NAME" ]; then
        echo -e "${RED}Nama theme diperlukan.${RESET}"
        return
    fi
    cd /var/www/pterodactyl || exit
    if [ ! -f "indolife.zip" ]; then
        git clone https://github.com/rizkiwibu/bukutulis.git
        cd  bukutulis
        sudo mv indolife.zip /var/www/pterodactyl
        cd /var/www/pterodactyl
    fi
    sudo unzip -o indolife.zip
    blueprint -i "$THEME_NAME"
    echo -e "${GREEN}Theme $THEME_NAME berhasil diinstal.${RESET}"
}
# Fungsi untuk menghapus seluruh tema Blueprint
remove_blueprint_themes() {
    echo -e "${CYAN}>> MENGHAPUS SELURUH TEMA BLUEPRINT <<${RESET}"
    cd /var/www/pterodactyl || exit
    echo -e "${YELLOW}Proses sedang berlangsung...${RESET}"
    yes | php artisan p:upgrade
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Seluruh tema Blueprint berhasil dihapus.${RESET}"
    else
        echo -e "${RED}Gagal menghapus tema Blueprint.${RESET}"
    fi
}
# Fungsi untuk install ulang Blueprint
reinstall_blueprint() {
    echo -e "${CYAN}>> INSTALL ULANG BLUEPRINT <<${RESET}"
    cd /var/www/pterodactyl || exit
    if command -v blueprint &> /dev/null; then
        echo -e "${YELLOW}Proses upgrade Blueprint sedang berlangsung...${RESET}"
        (echo "Y"; sleep 1; echo "continue"; sleep 1; echo "Y"; sleep 1; echo "y") | blueprint -upgrade
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Blueprint berhasil di-install ulang.${RESET}"
        else
            echo -e "${RED}Gagal meng-install ulang Blueprint.${RESET}"
        fi
    else
        echo -e "${RED}Blueprint belum terinstal. Pastikan Anda sudah menginstalnya terlebih dahulu.${RESET}"
    fi
}

# Menu pilihan
show_menu() {
    echo -e "${CYAN}Silakan pilih opsi instalasi:${RESET}"
    
    # Kelompok Wajib Install
    echo -e "${BOLD}${DARK_GREEN}[ Wajib Install ]${RESET}"
    echo -e "${YELLOW}1. Install Node.js dan Dependensi${RESET}"
    echo -e "${YELLOW}2. Install Blueprint (wajib)${RESET}"

    # Kelompok Tema Admin Panel
    echo -e "\n${BOLD}${DARK_GREEN}[ Tema Admin Panel ]${RESET}"
    echo -e "${YELLOW}3. Install AdminTheme Mythicalui${RESET}"
    echo -e "${YELLOW}4. Install AdminTheme Slate${RESET}"
    echo -e "${YELLOW}5. Install AdminTheme Nightadmin${RESET}"

    # Kelompok Tema Utama Pterodactyl
    echo -e "\n${BOLD}${DARK_GREEN}[ Tema Utama Pterodactyl ]${RESET}"
    echo -e "${YELLOW}6. Install Theme Nebula 2.0-1${RESET}"
    echo -e "${YELLOW}7. Install Theme Darkenate${RESET}"
    echo -e "${YELLOW}8. Install Theme Recolor${RESET}"

    # Kelompok Addons (Dekorasi Tambahan)
    echo -e "\n${BOLD}${DARK_GREEN}[ Fitur Addons ]${RESET}"
    echo -e "${YELLOW}9. Install addons Bluetables${RESET}"
    echo -e "${YELLOW}10. Install Addons Redirect${RESET}"
    echo -e "${YELLOW}11. Install Addons Snowflakes${RESET}"
    echo -e "${YELLOW}12. Install Addons Txadminintegration${RESET}"
    echo -e "${YELLOW}13. Install addons Simplefavicons${RESET}"

    # Kelompok Perbaikan Error
    echo -e "\n${BOLD}${DARK_GREEN}[ Perbaikan atau Install Ulang ]${RESET}"
    echo -e "${BOLD}${LIGHT_GREEN}14. Hapus Seluruh Tema Blueprint${RESET}"
    echo -e "${BOLD}${LIGHT_GREEN}15. Install Ulang Blueprint (Jika Ekstensi Error)${RESET}"

    # Keluar
    echo -e "\n${RED}16. Keluar${RESET}"
    echo -e "${WHITE}Pilih opsi [1-16]:${RESET}"
}
# Perulangan menu
while true; do
    show_animation
    show_menu
    read -r choice
    case $choice in
    1)
        install_node
        ;;
    2)
        install_blueprint
        ;;
    3)
        install_theme "mythicalui"
        ;;
    4)
        install_theme "slate"
        ;;
    5)
        install_theme "nightadmin"
        ;;
    6)
        install_theme "nebula"
        ;;
    7)
        install_theme "darkenate"
        ;;
    8)
        install_theme "recolor"
        ;;   
    9) 
        install_theme "bluetables"  
        ;;
    10)
        install_theme "redirect"
        ;;
    11)
        install_theme "snowflakes"
        ;;
    12)
        install_theme "txadminintegration"
        ;;
    13)
        install_theme "simplefavicons"
        ;;
    14)
        remove_blueprint_themes
        ;;
    15)
        reinstall_blueprint
        ;;           
    16)
    show_closing_animation
    sleep 2
    clear
    exit 0
    ;;
    *)
        echo -e "${RED}Pilihan tidak valid, coba lagi.${RESET}"
        ;;
    esac
done
