#!/bin/bash
set -e

if command -v termux-toast >/dev/null; then
    termux-toast "Sichere eigenen Account"
fi

# Pfade laut Übersicht.md
acc_eigene="/storage/emulated/0/MonopolyGo/Accounts/Eigene/"
acc_datapath="/data/data/com.scopely.monopolygo/files/DiskBasedCacheDirectory/WithBuddies.Services.User.0Production.dat"
acc_infos="/data/data/com.scopely.monopolygo/shared_prefs/com.scopely.monopolygo.v2.playerprefs.xml"
acc_eigene_infos="/storage/emulated/0/MonopolyGo/Accounts/Eigene/Accountinfos.json"

api_key="sk_MaQODQPO0HKJTZF1"
domain="go.babixgo.de"

read -r -p "Interne ID: " interneid
read -r -p "Notiz (optional): " notiz

# UserID aus Einstellungen auslesen
userid=$(grep -Po '<string name="Scopely.Attribution.UserId">\K[0-9]+' "$acc_infos" 2>/dev/null)
if [ -z "$userid" ]; then
    echo "UserId konnte nicht gefunden werden." >&2
    exit 1
fi

# Duplikate vermeiden
if [ -f "$acc_eigene_infos" ] && jq -e --arg id "$userid" --arg iid "$interneid" '.[] | select(.userid==$id or .interneid==$iid)' "$acc_eigene_infos" >/dev/null; then
    echo "Eintrag mit gleicher UserId oder Interne ID existiert bereits." >&2
    exit 1
fi

# Kurzlink erzeugen
orig_url="monopolygo://add-friend/$userid"
shortlink=$(curl -s -X POST \
    -H "authorization: $api_key" \
    -H "content-type: application/json" \
    -d "{\"domain\":\"$domain\",\"originalURL\":\"$orig_url\",\"path\":\"$interneid\",\"title\":\"$interneid\"}" \
    "https://api.short.io/links" | jq -r '.shortURL')
if [ -z "$shortlink" ] || [ "$shortlink" = "null" ]; then
    echo "Shortlink konnte nicht erstellt werden." >&2
    exit 1
fi

# Account-Datei kopieren
target_dir="${acc_eigene}${interneid}"
mkdir -p "$target_dir"
cp "$acc_datapath" "$target_dir/" || { echo "Kopieren fehlgeschlagen." >&2; exit 1; }
if command -v termux-toast >/dev/null; then
    termux-toast "Datei gesichert"
fi

datum=$(date +%Y-%m-%d)
entry=$(jq -n --arg iid "$interneid" --arg uid "$userid" --arg d "$datum" --arg sl "$shortlink" --arg n "$notiz" '{interneid:$iid, userid:$uid, datum:$d, shortlink:$sl, notiz:$n}')

if [ -f "$acc_eigene_infos" ]; then
    tmp=$(mktemp)
    jq --argjson e "$entry" '. + [$e]' "$acc_eigene_infos" > "$tmp" && mv "$tmp" "$acc_eigene_infos"
else
    echo "[$entry]" > "$acc_eigene_infos"
fi

echo "Account gesichert unter $target_dir"
if command -v termux-toast >/dev/null; then
    termux-toast "Account gesichert"
fi
