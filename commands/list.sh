#!/bin/bash

list_local() {
	echo "Local:"
	ls "$GODOT_DIR"
}

list_online() {
	local opt="${1:-s}"
	echo "Online:"

	curl -s -A "Mozilla/5.0" "https://godotengine.org/download/archive/" |
		grep -oP 'href=/download/archive/\K[^/"'\'' ><]+' |
		sort -Vr |
		uniq |
		case "$opt" in
		s)
			awk '/-(stable)[0-9]*$/'
			;;
		d)
			awk '/-(dev|beta|alpha|rc)[0-9]*$/'
			;;
		a)
			cat
			;;
		*)
			echo "Error: Opción inválida. Usa -s (stable), -d (dev) o -a (all)" >&2
			return 1
			;;
		esac
}
