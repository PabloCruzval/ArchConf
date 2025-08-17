# ArchConf - Dotfiles Configuration

Esta es la configuración de dotfiles para Arch Linux usando GNU Stow para la gestión de archivos de configuración.

## Estructura

```
ArchConf/
├── modules/                    # Módulos compartidos
│   ├── hyprland/              # Configuraciones modulares de Hyprland
│   │   ├── env.conf           # Variables de entorno
│   │   ├── input.conf         # Configuración de input
│   │   ├── general.conf       # Configuración general, decoraciones, animaciones
│   │   ├── keybinds.conf      # Atajos de teclado
│   │   ├── startup.conf       # Aplicaciones al inicio
│   │   ├── monitors-desktop.conf   # Configuración de monitores para PC
│   │   └── monitors-notebook.conf  # Configuración de monitores para notebook
│   ├── waybar/                # Configuraciones de Waybar
│   │   ├── waybar.jsonc       # Configuración principal
│   │   └── waybar.css         # Estilos
│   ├── kitty/                 # Configuración de Kitty
│   │   └── kitty.conf
│   ├── rofi/                  # Configuración de Rofi
│   │   └── config.rasi
│   └── zsh/                   # Configuración de ZSH
│       └── .zshrc
├── HyprlandPC/                # Configuración específica para PC de escritorio
│   └── .config/hypr/
│       └── hyprland.conf      # Importa módulos + monitors-desktop.conf
├── HyprlandNotebook/          # Configuración específica para notebook
│   └── .config/hypr/
│       └── hyprland.conf      # Importa módulos + monitors-notebook.conf
├── kitty/                     # Paquete Kitty para stow
│   └── .config/kitty/
├── waybar/                    # Paquete Waybar para stow
│   └── .config/waybar/
├── rofi/                      # Paquete Rofi para stow
│   └── .config/rofi/
├── zsh/                       # Paquete ZSH para stow
│   └── .zshrc
├── hyprpaper/                 # Paquete Hyprpaper para stow
│   └── .config/hypr/
└── wallpapers/                # Paquete Wallpapers para stow
    └── Wallpapers/
```

## Uso con Stow

### Instalación Automática (Recomendado)

Para una instalación fresca de Arch Linux, usa el script automático:

```bash
cd ArchConf
chmod +x install.sh
./install.sh
```

El script te permitirá:
1. **Instalación completa**: Instala todos los paquetes, configura servicios y despliega dotfiles
2. **Solo paquetes**: Instala únicamente los paquetes necesarios
3. **Solo servicios**: Configura servicios del sistema
4. **Solo dotfiles**: Despliega únicamente las configuraciones

### Instalación Manual

1. Clona este repositorio en tu directorio home o donde prefieras
2. Usa stow para crear los enlaces simbólicos:

```bash
cd ArchConf

# Configuraciones básicas (siempre necesarias)
stow kitty
stow waybar
stow rofi
stow zsh
stow hyprpaper
stow wallpapers

# Configuración de Hyprland específica por dispositivo
# Para PC de escritorio:
stow HyprlandPC

# Para notebook:
stow HyprlandNotebook
```

### Gestión de configuraciones

#### Hyprland Modular

La configuración de Hyprland está modularizada para facilitar el mantenimiento:

- **Módulos compartidos**: Se encuentran en `modules/hyprland/` y contienen configuraciones comunes
- **Configuraciones específicas**: Solo los monitores y workspaces son específicos por dispositivo

Para cambiar entre dispositivos:
```bash
# Desactivar configuración actual
stow -D HyprlandPC  # o HyprlandNotebook

# Activar nueva configuración
stow HyprlandNotebook  # o HyprlandPC
```

#### Otras aplicaciones

Las configuraciones de kitty, waybar, rofi y zsh son las mismas para ambos dispositivos.

### Dependencias

Para una instalación fresca de Arch Linux, instala los siguientes paquetes:

#### Paquetes básicos del sistema
```bash
# Hyprland y componentes del compositor
yay -S hyprland hypridle hyprpaper xdg-desktop-portal-hyprland

# Terminal y fuentes
yay -S kitty alacritty
yay -S ttf-firacode-nerd nerd-fonts ttf-fira-code

# Aplicaciones básicas de escritorio
yay -S waybar rofi thunar
yay -S brave-bin firefox
yay -S discord telegram-desktop spotify

# Herramientas de desarrollo
yay -S neovim visual-studio-code-bin
yay -S git gh nodejs npm pnpm
yay -S docker docker-compose
yay -S htop btop
yay -S gdb

# ZSH y herramientas de shell
yay -S zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions
yay -S fzf zoxide starship
yay -S eza bat ripgrep fd

# Multimedia y utilidades
yay -S pipewire pipewire-pulse pipewire-alsa
yay -S brightnessctl light
yay -S xclip wl-clipboard
yay -S grim slurp # Screenshots
yay -S pavucontrol # Control de audio
yay -S networkmanager nm-connection-editor

# Temas y cursores
yay -S bibata-cursor-theme
yay -S gnome-themes-extra adwaita-icon-theme
yay -S qt6ct kvantum

# Aplicaciones adicionales
yay -S obsidian gimp
yay -S syncthing
yay -S bitwarden
yay -S figma-linux
yay -S steam

# Para notebooks adicionales
yay -S acpi powertop tlp
```

#### Configuración post-instalación

```bash
# Habilitar servicios necesarios
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo systemctl enable --now pipewire pipewire-pulse

# Para notebooks, habilitar gestión de energía
sudo systemctl enable --now tlp

# Cambiar shell por defecto a ZSH
chsh -s /usr/bin/zsh

# Configurar Git (reemplaza con tus datos)
git config --global user.name "Tu Nombre"
git config --global user.email "tu.email@ejemplo.com"
```

#### Variables de entorno importantes

Agrega estas líneas a tu `~/.profile` o `~/.zprofile`:

```bash
# Qt theming
export QT_QPA_PLATFORMTHEME=qt6ct
export QT_STYLE_OVERRIDE=kvantum-dark

# Cursor theme
export XCURSOR_THEME=Bibata-Modern-Classic
export XCURSOR_SIZE=24

# Para NVIDIA (si tienes tarjeta NVIDIA)
export LIBVA_DRIVER_NAME=nvidia
export __GLX_VENDOR_LIBRARY_NAME=nvidia
```

### Personalización

1. **Modificar configuraciones compartidas**: Edita los archivos en `modules/`
2. **Modificar configuraciones específicas por dispositivo**: 
   - Para monitores: Edita `modules/hyprland/monitors-desktop.conf` o `monitors-notebook.conf`
   - Para otras diferencias: Edita directamente los archivos en `HyprlandPC/` o `HyprlandNotebook/`

### Theme

La configuración usa el tema Kanagawa en todas las aplicaciones para mantener consistencia visual.
