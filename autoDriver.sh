#!/bin/bash

# --- COLORES ---
CYAN='\e[1;36m'
RESET='\e[0m'
VERDE='\e[1;32m'

# 1. Limpiar pantalla
clear


# 2. Mostrar el Título AUTO en Verde Brillante
echo -e "${VERDE}"
cat << "EOF"
░█████╗░██╗░░░██╗████████╗░█████╗░
██╔══██╗██║░░░██║╚══██╔══╝██╔══██╗
███████║██║░░░██║░░░██║░░░██║░░██║
██╔══██║██║░░░██║░░░██║░░░██║░░██║
██║░░██║╚██████╔╝░░░██║░░░╚█████╔╝
╚═╝░░╚═╝░╚═════╝░░░░╚═╝░░░░╚════╝░
EOF
echo "          Hecho por: coffi"
echo -e "${RESET}"


# 4. Temporizador visual de 3 segundos
echo -n "Iniciando script en 3..."
sleep 1
echo -n " 2..."
sleep 1
echo -n " 1..."
sleep 1

# 5. Limpiar y empezar el script real
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
