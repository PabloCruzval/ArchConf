#!/usr/bin/env bash

# Monitor principal
PRIMARY="eDP-1"
PRIMARY_RES="1920x1080@60"

# Monitor secundario
SECONDARY="HDMI-A-1"
SECONDARY_RES="1920x1080@120"

# Verificar que Hyprland esté ejecutándose
if ! pgrep -x Hyprland > /dev/null; then
    echo "Error: Hyprland no está ejecutándose"
    exit 1
fi

# Verificar que los monitores estén conectados
if ! hyprctl monitors | grep -q "$SECONDARY"; then
    echo "Error: Monitor $SECONDARY no está conectado"
    exit 1
fi

echo "Configurando monitores..."

# Configurar posiciones con hyprctl
# eDP-1 como principal (a la derecha)
hyprctl keyword monitor "$PRIMARY,$PRIMARY_RES,1920x0,1"
# HDMI-A-1 a la izquierda
hyprctl keyword monitor "$SECONDARY,$SECONDARY_RES,0x0,1"

# Esperar un poco para que se apliquen los cambios
sleep 1

echo "Moviendo workspaces 1-5 a $SECONDARY..."

# Lista de workspaces a mover
WORKSPACES=(1 2 3 4 5)

# Función para verificar si un workspace existe
workspace_exists() {
    local ws=$1
    hyprctl workspaces -j | jq -r '.[].id' | grep -q "^$ws$"
    return $?
}

# Función para verificar si un workspace tiene ventanas
workspace_has_windows() {
    local ws=$1
    local window_count=$(hyprctl workspaces -j | jq -r ".[] | select(.id == $ws) | .windows")
    [ "$window_count" -gt 0 ] 2>/dev/null
}

# Función para verificar si un workspace tiene ventanas
workspace_has_windows() {
    local ws=$1
    local window_count=$(hyprctl workspaces -j | jq -r ".[] | select(.id == $ws) | .windows")
    [ "$window_count" -gt 0 ] 2>/dev/null
}

# Función para crear workspace con ventana temporal si es necesario
create_workspace_with_window() {
    local ws=$1
    local monitor=$2
    local temp_window_created=false
    local temp_window_address=""
    
    # Cambiar al workspace
    hyprctl dispatch workspace "$ws"
    sleep 0.3
    
    # Si el workspace no tiene ventanas, crear una temporal
    if ! workspace_has_windows "$ws"; then
        echo "Workspace $ws vacío, creando ventana temporal de kitty..."
        
        # Crear ventana temporal de kitty con título específico
        kitty --title "TEMP_WINDOW_$" --class "temp-window" -e sleep 10 &
        local kitty_pid=$!
        temp_window_created=true
        
        # Esperar a que la ventana aparezca
        sleep 0.5
        
        # Obtener la dirección de la ventana temporal
        temp_window_address=$(hyprctl clients -j | jq -r ".[] | select(.title == \"TEMP_WINDOW_$\") | .address")
    fi
    
    # Ahora mover el workspace al monitor
    echo "Moviendo workspace $ws a monitor $monitor..."
    hyprctl dispatch moveworkspacetomonitor "$ws $monitor"
    sleep 0.3
    
    # Si creamos ventana temporal, cerrarla
    if [ "$temp_window_created" = true ]; then
        if [ -n "$temp_window_address" ] && [ "$temp_window_address" != "null" ]; then
            echo "Cerrando ventana temporal..."
            hyprctl dispatch closewindow address:$temp_window_address
        fi
        # Por si acaso, también matar el proceso
        kill $kitty_pid 2>/dev/null || true
    fi
}

# Guardar workspace actual
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

# Iterar sobre los workspaces
for ws in "${WORKSPACES[@]}"; do
    echo "Procesando workspace $ws..."
    create_workspace_with_window "$ws" "$SECONDARY"
done

# Volver al workspace original
echo "Volviendo al workspace $CURRENT_WS"
hyprctl dispatch workspace "$CURRENT_WS"

# Configurar workspaces por defecto para cada monitor
echo "Configurando workspaces por defecto..."

# Workspaces 6-10 para el monitor principal
for ws in {6..10}; do
    if workspace_exists "$ws"; then
        hyprctl dispatch moveworkspacetomonitor "$ws $PRIMARY"
    fi
done

echo "Configuración completada:"
echo "- Monitor $PRIMARY: workspaces 6-10"
echo "- Monitor $SECONDARY: workspaces 1-5"
echo "- Resoluciones aplicadas: $PRIMARY_RES y $SECONDARY_RES"
