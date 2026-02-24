#!/bin/bash

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

# Ejecutar la intro
mostrar_intro

# 3. INTERFAZ DE SELECCIÓN (Checklist)
SELECCION=$(whiptail --title "Instalador AUTO - Menú de Selección" --checklist \
"Usa ESPACIO para marcar los programas que deseas instalar y presiona ENTER:" 20 75 10 \
"WIFI" "Driver Antena WiFi aic8800d80" ON \
"THUNDERBIRD" "Cliente de Correo Thunderbird (ES)" OFF \
"FIREFOX" "Navegador Firefox ESR (ES)" OFF \
"LIBREOFFICE" "Suite Ofimática LibreOffice (ES)" OFF \
3>&1 1>&2 2>&3)

# Salir si el usuario cancela o presiona Esc
if [ $? -ne 0 ]; then
    echo -e "\n${CYAN}Instalación cancelada por el usuario.${RESET}"
    exit
fi

# 4. EJECUCIÓN DEL SCRIPT PRINCIPAL
clear
echo -e "${VERDE}¡Ejecutando script principal!${RESET}"
BASE_DIR=$(pwd)

# Procesar cada selección
for APP in $SELECCION; do
    APP=$(echo $APP | tr -d '"') # Limpiar comillas de la variable

    case $APP in
        "WIFI")
            echo -e "\n${CYAN}--- Instalando Driver WiFi ---${RESET}"
            cd "$BASE_DIR/drivers/aic8800d80" || echo "Carpeta wifi no encontrada"
            chmod +x install.sh
            ./install.sh
            
            sleep 2
            if nmcli device | grep -q "wifi"; then
                echo "¡ÉXITO! El driver se activó correctamente."
            else
                echo "Aplicando corrección de firmware..."
                mkdir -p /lib/firmware/aic8800DC/
                find . -name "*.bin" -exec cp {} /lib/firmware/aic8800DC/ \;
                modprobe -r aic8800_fdrv
                modprobe aic8800_fdrv
            fi
            cd "$BASE_DIR"
            ;;

        "THUNDERBIRD")
            echo -e "\n${CYAN}--- Instalando Thunderbird ---${RESET}"
            cd "$BASE_DIR/programa/thunderbird/"
            # Instalamos las librerías y el programa todo junto
            sudo dpkg -i *.deb
            # Forzamos a que se configure todo sin borrar el programa
            sudo apt-get install -f -y
            ;;

        "FIREFOX")
            echo -e "\n${CYAN}--- Instalando Firefox ESR ---${RESET}"
            apt-get update
	    apt-get install firefox-esr firefox-esr-l10n-es-es -y
            ;;

        "LIBREOFFICE")
            echo -e "\n${CYAN}--- Instalando LibreOffice ---${RESET}"
            dpkg -i "$BASE_DIR/programa/libreOffice/LibreOffice_25.8.4.2_Linux_x86-64_deb/DEBS/"*.deb
            dpkg -i "$BASE_DIR/programa/libreOffice/LibreOffice_25.8.4.2_Linux_x86-64_deb_langpack_es/DEBS/"*.deb
            apt-get install -f -y
            ;;
    esac
done

echo -e "\n${VERDE}--- ¡PROCESO FINALIZADO CON ÉXITO! ---${RESET}"
