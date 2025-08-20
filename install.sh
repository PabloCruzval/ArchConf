#!/bin/bash

# ArchConf Installation Script
# Script para configurar una instalación fresca de Arch Linux

set -e

echo "🚀 ArchConf - Configuración automática para Arch Linux"
echo "=================================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para logs
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que estamos en el directorio correcto
if [ ! -f "README.md" ] || [ ! -d "modules" ]; then
    error "Este script debe ejecutarse desde el directorio ArchConf"
    exit 1
fi

# Verificar que yay está instalado
if ! command -v yay &> /dev/null; then
    error "yay no está instalado. Por favor instala yay primero."
    exit 1
fi

# Función para instalar paquetes
install_packages() {
    log "Instalando paquetes del sistema..."
    
    # Paquetes básicos del sistema
    yay -S --needed --noconfirm \
        hyprland-git hypridle-git hyprpaper-git xdg-desktop-portal-hyprland-git \
        kitty \
        ttf-firacode-nerd ttf-fira-code ttf-ubuntu-nerd noto-fonts-emoji noto-fonts \
        quickshell-git rofi thunar \
        brave-bin \
        neovim \
        git gh nodejs npm pnpm \
        htop btop \
        zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions \
        fzf zoxide starship \
        eza bat ripgrep fd \
        pulseaudio pulseaudio-alsa pulseaudio-bluetooth pulseaudio-jack \
        brightnessctl light \
        xclip wl-clipboard \
        grim slurp \
        pavucontrol \
        networkmanager nm-connection-editor \
        bibata-cursor-theme \
        gnome-themes-extra adwaita-icon-theme \
        qt6ct kvantum \
        bitwarden \
        acpi powertop tlp
}

# Función para instalar paquetes opcionales
install_optional_packages() {
    log "Instalando paquetes opcionales..."
    
    echo ""
    echo "¿Qué paquetes opcionales quieres instalar?"
    echo "1) Aplicaciones de comunicación (Discord, Telegram)"
    echo "2) Herramientas de desarrollo (VSCode, Docker, GDB)"
    echo "3) Multimedia y productividad (Spotify, Obsidian, GIMP, Figma)"
    echo "4) Aplicaciones adicionales (Steam, Syncthing, Firefox, Alacritty)"
    echo "5) Todos los anteriores"
    echo "6) Ninguno (solo paquetes básicos)"
    echo ""
    read -p "Selecciona una opción (1-6): " optional_choice
    
    case $optional_choice in
        1|5)
            log "Instalando aplicaciones de comunicación..."
            yay -S --needed --noconfirm discord telegram-desktop
            ;;
    esac
    
    case $optional_choice in
        2|5)
            log "Instalando herramientas de desarrollo..."
            yay -S --needed --noconfirm visual-studio-code-bin docker docker-compose gdb
            ;;
    esac
    
    case $optional_choice in
        3|5)
            log "Instalando multimedia y productividad..."
            yay -S --needed --noconfirm spotify obsidian gimp figma-linux
            ;;
    esac
    
    case $optional_choice in
        4|5)
            log "Instalando aplicaciones adicionales..."
            yay -S --needed --noconfirm steam syncthing firefox alacritty
            ;;
    esac
    
    if [ "$optional_choice" == "6" ]; then
        log "Saltando paquetes opcionales."
    fi
}

# Función para habilitar servicios
enable_services() {
    log "Habilitando servicios del sistema..."
    
    sudo systemctl enable --now NetworkManager || warn "No se pudo habilitar NetworkManager"
    sudo systemctl enable --now bluetooth || warn "No se pudo habilitar Bluetooth"
    sudo systemctl enable --now pulseaudio || warn "No se pudo habilitar PulseAudio"
    
    # Para notebooks
    if [ -f "/sys/class/power_supply/BAT0/capacity" ] || [ -f "/sys/class/power_supply/BAT1/capacity" ]; then
        log "Detectado notebook, habilitando TLP..."
        sudo systemctl enable --now tlp || warn "No se pudo habilitar TLP"
    fi
}

# Función para configurar ZSH
setup_zsh() {
    log "Configurando ZSH como shell por defecto..."
    
    if [ "$SHELL" != "/usr/bin/zsh" ]; then
        chsh -s /usr/bin/zsh
        log "ZSH configurado como shell por defecto. Necesitarás reiniciar sesión."
    fi
}

# Función para configurar Git
setup_git() {
    log "Configurando Git..."
    
    if [ -z "$(git config --global user.name)" ]; then
        read -p "Ingresa tu nombre para Git: " git_name
        git config --global user.name "$git_name"
    fi
    
    if [ -z "$(git config --global user.email)" ]; then
        read -p "Ingresa tu email para Git: " git_email
        git config --global user.email "$git_email"
    fi
}

# Función para instalar configuraciones con stow
install_configs() {
    log "Instalando configuraciones con stow..."
    
    if ! command -v stow &> /dev/null; then
        log "Instalando stow..."
        yay -S --needed --noconfirm stow
    fi
    
    # Configuraciones básicas
    stow kitty
    stow quickshell
    stow rofi
    stow zsh
    stow hyprpaper
    stow wallpapers
    
    log "QuickShell configurado como barra principal"
    
    # Preguntar por configuración de Hyprland
    echo ""
    echo "¿Qué configuración de Hyprland quieres usar?"
    echo "1) PC de escritorio (multi-monitor)"
    echo "2) Notebook (single monitor)"
    read -p "Selecciona (1/2): " hyprland_choice
    
    case $hyprland_choice in
        1)
            stow HyprlandPC
            log "Configuración de Hyprland para PC instalada"
            ;;
        2)
            stow HyprlandNotebook
            log "Configuración de Hyprland para Notebook instalada"
            ;;
        *)
            warn "Selección inválida, saltando configuración de Hyprland"
            ;;
    esac
}

# Función para crear archivos de entorno
create_env_files() {
    log "Creando archivos de variables de entorno..."
    
    # Crear ~/.profile si no existe
    if [ ! -f "$HOME/.profile" ]; then
        cat > "$HOME/.profile" << 'EOF'
# ~/.profile: executed by the command interpreter for login shells.

# Qt theming
export QT_QPA_PLATFORMTHEME=qt6ct
export QT_STYLE_OVERRIDE=kvantum-dark

# Cursor theme
export XCURSOR_THEME=Bibata-Modern-Classic
export XCURSOR_SIZE=24

# Path additions
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
EOF
        log "Archivo ~/.profile creado"
    fi
}

# Menú principal
main() {
    echo ""
    echo "¿Qué quieres hacer?"
    echo "1) Instalación completa (recomendado para sistema nuevo)"
    echo "2) Solo instalar paquetes básicos"
    echo "3) Solo instalar paquetes opcionales"
    echo "4) Solo configurar servicios"
    echo "5) Solo instalar configuraciones (dotfiles)"
    echo "6) Salir"
    echo ""
    read -p "Selecciona una opción (1-6): " choice
    
    case $choice in
        1)
            install_packages
            install_optional_packages
            enable_services
            setup_zsh
            setup_git
            create_env_files
            install_configs
            log "¡Instalación completa terminada! Reinicia tu sesión para aplicar todos los cambios."
            ;;
        2)
            install_packages
            log "Paquetes básicos instalados."
            ;;
        3)
            install_optional_packages
            log "Paquetes opcionales instalados."
            ;;
        4)
            enable_services
            log "Servicios configurados."
            ;;
        5)
            install_configs
            log "Configuraciones instaladas."
            ;;
        6)
            log "Saliendo..."
            exit 0
            ;;
        *)
            error "Opción inválida"
            exit 1
            ;;
    esac
}

# Ejecutar menú principal
main
