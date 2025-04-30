#!/bin/bash

source "$(dirname "$0")/../lib/config.sh"
source "$(dirname "$0")/../commands/download.sh"

remove_version() {

	local version="$1"
	local version_dir="${LOCAL_VERSIONS_DIR}/${version}"

	if [ ! -d "$version_dir" ]; then
		return 0
	fi

	DESKTOP_FILE=~/.local/share/applications/godot-"$version".desktop
	EXTRACTED_FILE=$(find "$version_dir" -maxdepth 1 -type f -printf "%T@ %p\n" | sort -n | tail -n1 | cut -d' ' -f2-)

	rm -f "$EXTRACTED_FILE"
	rmdir "$version_dir"
	rm -f "$DESKTOP_FILE"

	echo "Godot Engine $version has been completely removed"
}
