#!/bin/bash

source "$(dirname "$0")/../lib/config.sh"

download_version() {
	local version="$1"
	local version_dir="${LOCAL_DOWNLOAD_DIR}/${version}"
	local url filename full_path

	# Crear directorio específico para la versión
	if ! mkdir -p "$version_dir"; then
		echo "Error crítico: No se pudo crear directorio para $version" >&2
		return 1
	fi

	# Obtener URL
	url=$(curl -sL -A "Mozilla/5.0" "https://godotengine.org/download/archive/${version}/" |
		grep -oP 'href=\K[^>]+(?=>Linux)' | head -1)

	# Verificar si se encontró URL
	if [[ -z "$url" ]]; then
		echo "Error: No se pudo encontrar enlace de descarga para $version" >&2
		return 1
	fi

	# Extraer nombre de archivo desde la URL
	filename=$(basename "$url")
	full_path="${version_dir}/${filename}"

	# Verificar si el archivo ya existe
	if [[ -f "$full_path" ]]; then
		echo "Descarga existente: ${filename}"
		echo "Ruta: ${full_path}"
		return 0
	fi

	# Indicamos el proceso
	echo "Descargando Godot ${version}"
	echo "URL verificada: ${url}"
	echo "Destino: ${full_path}"
	echo "────────────────────────────────────"

	# Descarga
	if curl -#L --fail --retry 3 --output "${full_path}.tmp" "$url"; then
		# Verificar tipo MIME del archivo
		if file --mime-type "${full_path}.tmp" | grep -q 'application/zip'; then
			mv "${full_path}.tmp" "$full_path"
			echo "Descarga validada correctamente"
			echo "Tamaño: $(du -h "$full_path" | cut -f1)"
			return 0
		else
			echo "Error: El archivo descargado no es un ZIP válido"
			rm -f "${full_path}.tmp"
			return 1
		fi
	else
		echo "Error: Fallo en la descarga (código $?)"
		rm -f "${full_path}.tmp"
		return 1
	fi
}
