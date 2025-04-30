#!/bin/bash

source "$(dirname "$0")/../lib/config.sh"
source "$(dirname "$0")/../lib/utils.sh"
source "$(dirname "$0")/../commands/list.sh"
source "$(dirname "$0")/../commands/download.sh"
source "$(dirname "$0")/../commands/remove.sh"
source "$(dirname "$0")/../commands/install.sh"

while getopts "l o: d: i: r:" opt; do
	case "$opt" in
	l)
		list_local
		;;
	o)
		list_online "$OPTARG"
		;;
	d)
		download_version "$OPTARG"
		;;
	r)
		remove_version "$OPTARG"
		;;
	i)
		install_version "$OPTARG"
		;;
	\?)
		echo "Opción inválida: -$OPTARG"
		;;
	esac
done
