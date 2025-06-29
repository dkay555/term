#!/bin/bash
set -e
# Master script for Emulatoreinrichtung module
PS3="Aktion wählen: "
options=(
    "Download Dateien"
    "IDs ändern"
    "Abbrechen"
)
select opt in "${options[@]}"; do
    case "$REPLY" in
        1)
            cmd="1_Download.sh"
            ;;
        2)
            cmd="2_Aendere_Ids.sh"
            ;;
        3)
            echo "Abgebrochen."
            exit 0
            ;;
        *)
            echo "Ungültige Auswahl." >&2
            continue
            ;;
    esac

    if command -v termux-toast >/dev/null; then
        termux-toast "Starte $cmd"
    fi

    bash "$cmd"

    if command -v termux-toast >/dev/null; then
        termux-toast "Fertig: $cmd"
    fi
    break

done
