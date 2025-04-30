#!/bin/bash

# Variables
CONFIG_DIR="$HOME/.config/godot_manager"
VERSIONS_DIR="$CONFIG_DIR/versions"
BIN_DIR="$HOME/.local/bin"
MAIN_SCRIPT="$CONFIG_DIR/bin/godot_manager.sh"
LINK_PATH="$BIN_DIR/godot_manager"

# Crear estructura de directorios
mkdir -p "$CONFIG_DIR"
mkdir -p "$VERSIONS_DIR"
mkdir -p "$BIN_DIR"

# Copiar archivos del proyecto
cp -r bin lib "$CONFIG_DIR"

# Asegurar permisos de ejecución
chmod +x "$MAIN_SCRIPT"
find "$CONFIG_DIR/lib" -type f -name "*.sh" -exec chmod +x {} \;

# Crear enlace simbólico
ln -sf "$MAIN_SCRIPT" "$LINK_PATH"

# Confirmación final
echo "Instalación completada."
