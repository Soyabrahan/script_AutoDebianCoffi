# 🚀 AutoDebianCoffi - Script de Automatización para Canaima/Debian12 hecho para Ferrominera

Este proyecto nace para facilitar la post-instalación y configuración de sistemas Canaima (basados en Debian), optimizando el tiempo de técnicos y usuarios finales.

> **⚠️ IMPORTANTE:** Actualmente este script **solo soporta arquitecturas de 64 bits (amd64)**. El soporte para Canaima 32 bits (i386) está en desarrollo.

---

## 📦 Versiones y Componentes Utilizados

Para garantizar la estabilidad, se han seleccionado versiones específicas que han demostrado ser compatibles con el entorno de Canaima:

| Software | Versión Incluida | Arquitectura |
| :--- | :--- | :--- |
| **Mozilla Thunderbird** | 140.7.1esr-1 | amd64 |
| **Mozilla Firefox** | 147.0.3 | amd64 |
| **LibreOffice** | 25.8.4.2 | amd64 |
| **Thunderbird L10n** | Español (es-es) | all |

### 📂 Alojamiento de Archivos Pesados
Debido a las restricciones de tamaño de GitHub, los instaladores binarios (`.deb`, `.tar.xz`) **no se encuentran en este repositorio**. 
Para ejecutar el script completo, debes descargar el paquete de instaladores y colocarlos en sus respectivas carpetas dentro de `programa/`:


## 🛠️ Modos de Uso Especiales

El proyecto incluye dos variantes modificadas para necesidades específicas:

### 1. 📶 AutoDriver (WiFi Edition)
Es una versión optimizada exclusivamente para la **gestión de conectividad**. 
- Detecta e instala automáticamente los firmwares necesarios para las antenas WiFi (Broadcom, Realtek, Atheros).
- Ideal para equipos donde el sistema reconoce la tarjeta pero no activa el WiFi por falta de componentes *non-free*.

### 2. ⚡ AutoInstall (Directo)
Esta versión está diseñada para la rapidez total.
- A diferencia del script principal, no muestra menús de selección.
- Ejecuta la instalación en cadena de todos los programas (Firefox, Thunderbird, LibreOffice y Drivers) de forma directa.
- Ideal para despliegues masivos en laboratorios o oficinas.

---

## 🚀 Cómo empezar

1. **Clonar el repositorio:**
   ```bash
   git clone [https://github.com/Soyabrahan/script_AutoDebianCoffi.git](https://github.com/Soyabrahan/script_AutoDebianCoffi.git)

2.descargar los archivos pesados , incluido el zip del driver
3.darle permisos de ejecucion chmod 500 o chmod u+x,u+w menuInstall.sh
4.ejecutar con sudo ./menuInstall.sh
