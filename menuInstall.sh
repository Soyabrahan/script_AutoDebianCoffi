#!/bin/bash

# --- CONFIGURACIÓN DE COLORES ---
CYAN='\e[1;36m'
VERDE='\e[1;32m'
ROJO='\e[1;31m'
RESET='\e[0m'

# 1. FUNCIÓN DE INTRODUCCIÓN
mostrar_intro() {
    clear
    echo -e "${VERDE}"
    cat << "EOF"
░█████╗░██╗░░░██╗████████╗░█████╗░
██╔══██╗██║░░░██║╚══██╔══╝██╔══██╗
███████║██║░░░██║░░░██║░░░██║░░██║
██╔══██║██║░░░██║░░░██║░░░██║░░██║
██║░░██║╚██████╔╝░░░██║░░░╚█████╔╝
╚═╝░░╚═╝░╚═════╝░░░░╚═╝░░░░╚════╝░
EOF
    echo -e "${CYAN}          Hecho por: coffi${RESET}"
    echo -e "${CYAN}    Fase Obligatoria: Actualización a Trixie${RESET}\n"
}

# 2. VERIFICACIÓN DE PRIVILEGIOS Y ARQUITECTURA
if [ "$EUID" -ne 0 ]; then 
  echo -e "${ROJO}Por favor, ejecuta el script con sudo: sudo ./script.sh${RESET}"
  exit
fi

ARCH=$(getconf LONG_BIT)
mostrar_intro

# 3. INTERFAZ DE SELECCIÓN (Sin la opción de Repos, es automático)
SELECCION=$(whiptail --title "Instalador AUTO - Selección ($ARCH bits)" --checklist \
"Selecciona los programas adicionales. (Repositorios Trixie se configurarán primero):" 20 75 10 \
"WIFI" "Driver Antena WiFi aic8800d80" ON \
"THUNDERBIRD" "Correo Thunderbird" OFF \
"FIREFOX" "Navegador Firefox ESR" OFF \
"LIBREOFFICE" "Suite Ofimática" OFF \
"REMMINA" "Remmina (vía Flatpak)" OFF \
3>&1 1>&2 2>&3)

if [ $? -ne 0 ]; then exit; fi

clear

# --- FASE 1: ACTUALIZACIÓN OBLIGATORIA DE REPOSITORIOS ---
echo -e "${VERDE} [PASO 1/2] Configurando Repositorios Debian Trixie (Obligatorio)${RESET}"
# Respaldar original
cp /etc/apt/sources.list /etc/apt/sources.list.bak

# Sobrescribir con Trixie
cat << EOF > /etc/apt/sources.list
deb http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware

deb http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
EOF

echo -e "${CYAN}Sincronizando nuevos repositorios...${RESET}"
apt-get update

echo -e "${CYAN}Instalando btop para verificar conexión...${RESET}"
apt-get install btop -y

if [ $? -eq 0 ]; then
    echo -e "${VERDE}¡Conexión exitosa! Sistema listo para instalar programas.${RESET}"
else
    echo -e "${ROJO}Atención: Error de conexión. El proceso intentará continuar con los archivos locales.${RESET}"
fi

# --- FASE 2: INSTALACIÓN DE SELECCIÓN ---
echo -e "\n${VERDE} [PASO 2/2] Instalando aplicaciones seleccionadas...${RESET}"
BASE_DIR=$(pwd)

for APP in $SELECCION; do
    APP=$(echo $APP | tr -d '"')

    case $APP in
        "WIFI")
            echo -e "\n${CYAN}--- Instalando Driver WiFi ---${RESET}"
            cd "$BASE_DIR/drivers/aic8800d80" && chmod +x install.sh && ./install.sh
            cd "$BASE_DIR"
            ;;

        "THUNDERBIRD")
            echo -e "\n${CYAN}--- Instalando Thunderbird ---${RESET}"
            if [ "$ARCH" = "64" ]; then
                cd "$BASE_DIR/programa/thunderbird/" && dpkg -i *.deb
                apt-get install -f -y
            else
                apt-get install thunderbird thunderbird-l10n-es-es -y
            fi
            ;;

        "FIREFOX")
            echo -e "\n${CYAN}--- Instalando Firefox ESR ---${RESET}"
            apt-get install firefox-esr firefox-esr-l10n-es-es -y
            ;;

        "LIBREOFFICE")
            echo -e "\n${CYAN}--- Instalando LibreOffice ---${RESET}"
            if [ "$ARCH" = "64" ]; then
                dpkg -i "$BASE_DIR/programa/libreOffice/LibreOffice_25.8.4.2_Linux_x86-64_deb/DEBS/"*.deb
                dpkg -i "$BASE_DIR/programa/libreOffice/LibreOffice_25.8.4.2_Linux_x86-64_deb_langpack_es/DEBS/"*.deb
                apt-get install -f -y
            else
                apt-get install libreoffice libreoffice-l10n-es -y
            fi
            ;;

        "REMMINA")
            echo -e "\n${CYAN}--- Instalando Remmina vía Flatpak ---${RESET}"
            apt-get install flatpak -y
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            flatpak install flathub org.remmina.Remmina -y
            ;;
    esac
done

echo -e "\n${VERDE}--- ¡PROCESO FINALIZADO CON ÉXITO POR COFFI! ---${RESET}"