##!/bin/bash

# --- CONFIGURACIÓN DE COLORES ---
CYAN='\e[1;36m'
VERDE='\e[1;32m'
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
    echo ""
    
    # Temporizador visual
    for i in {3..1}; do
        echo -ne "Iniciando interfaz de selección en $i... \r"
        sleep 1
    done
}

# 2. VERIFICACIÓN DE PRIVILEGIOS
if [ "$EUID" -ne 0 ]; then 
  echo -e "${CYAN}Por favor, ejecuta el script con sudo: sudo ./script.sh${RESET}"
  exit
fi

# 3. Limpiar y empezar el script real
#clear
echo "¡Ejecutando script principal!"
#base
BASE_DIR=$(pwd)

# 1. Driver Antena WIFI
echo "--- Instalando Driver WiFi ---"
cd "$BASE_DIR/drivers/aic8800d80" || exit
chmod +x install.sh
sudo ./install.sh

# Verificación y corrección de firmware
sleep 2
if nmcli device | grep -q "wifi"; then
    echo "¡ÉXITO! El driver se activó correctamente."
else
    echo "Aplicando corrección de firmware..."
    sudo mkdir -p /lib/firmware/aic8800DC/
    find . -name "*.bin" -exec sudo cp {} /lib/firmware/aic8800DC/ \;
    sudo modprobe -r aic8800_fdrv
    sudo modprobe aic8800_fdrv
fi

# Volvemos a la base para seguir con los programas
cd "$BASE_DIR"

# 2. Thunderbird
echo -e "\n${CYAN}--- Instalando Thunderbird ---${RESET}"
cd "$BASE_DIR/programa/thunderbird/"
# Instalamos las librerías y el programa todo junto
sudo dpkg -i *.deb
# Forzamos a que se configure todo sin borrar el programa
sudo apt-get install -f -y

# 3. Firefox ESR
echo "--- Instalando Firefox ESR ---"
apt-get update
apt-get install firefox-esr firefox-esr-l10n-es-es -y

# 4. LibreOffice
# Usamos rutas directas para no perdernos con tanto 'cd'
echo -e "\n${CYAN}--- Instalando LibreOffice ---${RESET}"
dpkg -i "$BASE_DIR/programa/libreOffice/LibreOffice_25.8.4.2_Linux_x86-64_deb/DEBS/"*.deb
dpkg -i "$BASE_DIR/programa/libreOffice/LibreOffice_25.8.4.2_Linux_x86-64_deb_langpack_es/DEBS/"*.deb
apt-get install -f -y
          

echo "--- ¡PROCESO FINALIZADO CON ÉXITO! ---"
