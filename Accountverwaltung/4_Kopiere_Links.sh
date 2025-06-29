#!/bin/bash
set -e

if command -v termux-toast >/dev/null; then
    termux-toast "Kopiere Links"
fi

# Pfad zur Accountinfo-JSON
acc_eigene_infos="/storage/emulated/0/MonopolyGo/Accounts/Eigene/Accountinfos.json"

if [ ! -f "$acc_eigene_infos" ]; then
    echo "Accountinfo-Datei nicht gefunden." >&2
    exit 1
fi

# Interne IDs aus JSON einlesen
mapfile -t interneids < <(jq -r '.[].interneid' "$acc_eigene_infos")

if [ ${#interneids[@]} -eq 0 ]; then
    echo "Keine Accounts vorhanden." >&2
    exit 1
fi

echo "Verfügbare Accounts:"
for i in "${!interneids[@]}"; do
    printf "%d) %s\n" $((i+1)) "${interneids[$i]}"
done

read -r -p "Nummern auswählen (z.B. 1 2 5): " selection

links=()
for num in $selection; do
    idx=$((num-1))
    if [ $idx -ge 0 ] && [ $idx -lt ${#interneids[@]} ]; then
        link=$(jq -r --arg iid "${interneids[$idx]}" '.[] | select(.interneid==$iid) | .shortlink' "$acc_eigene_infos")
        if [ -n "$link" ] && [ "$link" != "null" ]; then
            links+=("$link")
        fi
    fi
done

if [ ${#links[@]} -eq 0 ]; then
    echo "Keine gültigen Nummern gewählt." >&2
    exit 1
fi

output=$(printf "%s\n" "${links[@]}")

if command -v termux-clipboard-set >/dev/null 2>&1; then
    printf "%s" "$output" | termux-clipboard-set
    echo "Links in die Zwischenablage kopiert."
    if command -v termux-toast >/dev/null; then
        termux-toast "Links kopiert"
    fi
elif command -v xclip >/dev/null 2>&1; then
    printf "%s" "$output" | xclip -selection clipboard
    echo "Links in die Zwischenablage kopiert."
    if command -v termux-toast >/dev/null; then
        termux-toast "Links kopiert"
    fi
else
    echo "Zwischenablage-Tool nicht gefunden. Hier die Links:" >&2
    echo "$output"
    if command -v termux-toast >/dev/null; then
        termux-toast "Links ausgegeben"
    fi
fi
