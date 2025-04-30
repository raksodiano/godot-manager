#!/bin/bash

source "$(dirname "$0")/../lib/config.sh"
source "$(dirname "$0")/../commands/download.sh"

install_version() {

	local version="$1"
	local version_dir="${LOCAL_VERSIONS_DIR}/${version}"
	local version_download_dir="${LOCAL_DOWNLOAD_DIR}/${version}"

	if [ ! -d "$version_dir" ]; then
		if [ ! -d "$version_download_dir" ]; then
			download_version "$version"
		fi
	fi

	# Crear directorio específico para la versión
	if ! mkdir -p "$version_download_dir"; then
		echo "Error crítico: No se pudo crear directorio para $version" >&2
		return 1
	fi

	unzip "$version_download_dir"/*.zip -d "$version_dir"

	EXTRACTED_FILE=$(find "$version_dir" -maxdepth 1 -type f -printf "%T@ %p\n" | sort -n | tail -n1 | cut -d' ' -f2-)

	chmod +x "$EXTRACTED_FILE"
	mkdir -p ~/.local/share/applications

	# Construir nombre del archivo .desktop
	DESKTOP_FILE=~/.local/share/applications/godot-"$version".desktop

	# Crear archivo .desktop
	cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Godot Engine $version
Exec=$EXTRACTED_FILE
Icon=godot
Type=Application
Categories=Development;IDE;
Terminal=false
EOF

	echo "Godot Engine $version was successfully installed"
}
