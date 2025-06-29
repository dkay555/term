#!/bin/bash
set -e
# Master script for the Accounterstellung module
PS3="Aktion wählen: "
options=(
    "Termux Variante"
    "Verbinden"
    "APK installieren"
    "Taps ausführen"
    "Daten sichern"
    "Abbrechen"
)
select opt in "${options[@]}"; do
    case "$REPLY" in
        1)
            cmd="1_Termux_Variante.sh"
            ;;
        2)
            cmd="2_Verbinden.sh"
            ;;
        3)
            cmd="3_APK_installieren.sh"
            ;;
        4)
            cmd="4_Taps_ausfuehren.sh"
            ;;
        5)
            cmd="5_Daten_sichern.sh"
            ;;
        6)
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
