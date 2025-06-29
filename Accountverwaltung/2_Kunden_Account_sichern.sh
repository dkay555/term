#!/bin/bash
set -e

if command -v termux-toast >/dev/null; then
    termux-toast "Sichere Kundenaccount"
fi

# Pfade laut Übersicht.md
acc_kunden="/storage/emulated/0/MonopolyGo/Accounts/Kunden/"
acc_datapath="/data/data/com.scopely.monopolygo/files/DiskBasedCacheDirectory/WithBuddies.Services.User.0Production.dat"
acc_infos="/data/data/com.scopely.monopolygo/shared_prefs/com.scopely.monopolygo.v2.playerprefs.xml"
acc_kunden_infos="/storage/emulated/0/MonopolyGo/Accounts/Kunden/Kundeninfos.json"

extract_userid_from_link() {
    local url="$1"
    curl -sIL "$url" | grep -i "^location:" | tail -n1 | grep -Po '(?<=/add-friend/)[0-9]+'
}

read -r -p "Kunden ID (Name+Nummer): " kundenid
read -r -p "Nutzername: " nutzername
read -r -p "Passwort: " pass
read -r -p "AuTok: " autok
read -r -p "Freundschaftslink: " freundschaftslink
read -r -p "Code: " code
read -r -p "Notiz (optional): " notiz
read -r -p "Accountdateien mitsichern? [j/N] " save_files

userid=$(extract_userid_from_link "$freundschaftslink")
if [[ $save_files =~ ^[Jj]$ ]]; then
    file_uid=$(grep -Po '<string name="Scopely.Attribution.UserId">\\K[0-9]+' "$acc_infos" 2>/dev/null)
    if [ -n "$file_uid" ]; then
        userid="$file_uid"
    fi
fi

if [ -z "$userid" ]; then
    echo "UserID konnte nicht ermittelt werden." >&2
    exit 1
fi

if [ -f "$acc_kunden_infos" ]; then
    if jq -e --arg kid "$kundenid" --arg uid "$userid" '.[] | select(.kundenid==$kid or (.userid==$uid and $uid!=""))' "$acc_kunden_infos" >/dev/null; then
        echo "Eintrag mit gleicher Kunden ID oder UserId existiert bereits." >&2
        exit 1
    fi
fi

if [[ $save_files =~ ^[Jj]$ ]]; then
    target_dir="${acc_kunden}${kundenid}"
    mkdir -p "$target_dir"
    cp "$acc_datapath" "$target_dir/" || { echo "Kopieren fehlgeschlagen." >&2; exit 1; }
    if command -v termux-toast >/dev/null; then
        termux-toast "Dateien kopiert"
    fi
fi

entry=$(jq -n \
    --arg kid "$kundenid" \
    --arg nu "$nutzername" \
    --arg pa "$pass" \
    --arg au "$autok" \
    --arg fl "$freundschaftslink" \
    --arg co "$code" \
    --arg uid "$userid" \
    --arg no "$notiz" \
    '{kundenid:$kid, nutzername:$nu, pass:$pa, autok:$au, freundschaftslink:$fl, code:$co, userid:($uid // empty), notiz:$no}')

if [ -f "$acc_kunden_infos" ]; then
    tmp=$(mktemp)
    jq --argjson e "$entry" '. + [$e]' "$acc_kunden_infos" > "$tmp" && mv "$tmp" "$acc_kunden_infos"
else
    echo "[$entry]" > "$acc_kunden_infos"
fi

echo "Kundenaccount-Daten gespeichert."
if command -v termux-toast >/dev/null; then
    termux-toast "Daten gespeichert"
fi
if [[ $save_files =~ ^[Jj]$ ]]; then
    echo "Accountdateien gesichert unter $target_dir"
fi
