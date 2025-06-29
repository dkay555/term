#!/bin/bash
set -e

if command -v termux-toast >/dev/null; then
    termux-toast "Infos bearbeiten"
fi

# Pfade laut Übersicht.md
acc_eigene_infos="/storage/emulated/0/MonopolyGo/Accounts/Eigene/Accountinfos.json"
acc_kunden_infos="/storage/emulated/0/MonopolyGo/Accounts/Kunden/Kundeninfos.json"

extract_userid_from_link() {
    local url="$1"
    curl -sIL "$url" | grep -i "^location:" | tail -n1 | grep -Po '(?<=/add-friend/)[0-9]+'
}

PS3="Quelle auswählen: "
select src in "Eigene Accounts" "Kunden Accounts" "Abbrechen"; do
    case "$src" in
        "Eigene Accounts") infos_file="$acc_eigene_infos"; key="interneid"; break;;
        "Kunden Accounts") infos_file="$acc_kunden_infos"; key="kundenid"; break;;
        "Abbrechen") echo "Abgebrochen."; exit 0;;
    esac
done

if [ ! -f "$infos_file" ]; then
    echo "Infos-Datei nicht gefunden: $infos_file" >&2
    exit 1
fi

mapfile -t ids < <(jq -r ".[] | .$key" "$infos_file")

if [ ${#ids[@]} -eq 0 ]; then
    echo "Keine Einträge gefunden." >&2
    exit 1
fi

PS3="Account auswählen: "
select id in "${ids[@]}" "Abbrechen"; do
    if [ "$REPLY" -gt 0 ] && [ "$REPLY" -le ${#ids[@]} ]; then
        selected="$id"
        break
    else
        echo "Abgebrochen."; exit 0
    fi
done

entry=$(jq -r --arg sel "$selected" --arg k "$key" '.[] | select(.[$k]==$sel)' "$infos_file")
if [ -z "$entry" ]; then
    echo "Eintrag nicht gefunden." >&2
    exit 1
fi

update_eigene() {
    interneid=$(jq -r '.interneid' <<<"$entry")
    userid=$(jq -r '.userid' <<<"$entry")
    datum=$(jq -r '.datum' <<<"$entry")
    shortlink=$(jq -r '.shortlink' <<<"$entry")
    notiz=$(jq -r '.notiz' <<<"$entry")

    read -r -p "Interne ID [$interneid]: " val; interneid=${val:-$interneid}
    read -r -p "UserId [$userid]: " val; userid=${val:-$userid}
    read -r -p "Datum [$datum]: " val; datum=${val:-$datum}
    read -r -p "Shortlink [$shortlink]: " val; shortlink=${val:-$shortlink}
    read -r -p "Notiz [$notiz]: " val; notiz=${val:-$notiz}

    jq -n --arg interneid "$interneid" --arg userid "$userid" \
          --arg datum "$datum" --arg shortlink "$shortlink" --arg notiz "$notiz" \
          '{interneid:$interneid, userid:$userid, datum:$datum, shortlink:$shortlink, notiz:$notiz}'
}

update_kunden() {
    kundenid=$(jq -r '.kundenid' <<<"$entry")
    nutzername=$(jq -r '.nutzername' <<<"$entry")
    pass=$(jq -r '.pass' <<<"$entry")
    autok=$(jq -r '.autok' <<<"$entry")
    freundschaftslink=$(jq -r '.freundschaftslink' <<<"$entry")
    code=$(jq -r '.code' <<<"$entry")
    userid=$(jq -r '.userid // ""' <<<"$entry")
    notiz=$(jq -r '.notiz' <<<"$entry")

    read -r -p "Kunden ID [$kundenid]: " val; kundenid=${val:-$kundenid}
    read -r -p "Nutzername [$nutzername]: " val; nutzername=${val:-$nutzername}
    read -r -p "Passwort [$pass]: " val; pass=${val:-$pass}
    read -r -p "AuTok [$autok]: " val; autok=${val:-$autok}
    read -r -p "Freundschaftslink [$freundschaftslink]: " val; freundschaftslink=${val:-$freundschaftslink}
    auto_uid=$(extract_userid_from_link "$freundschaftslink")
    read -r -p "Code [$code]: " val; code=${val:-$code}
    if [ -n "$auto_uid" ]; then
        userid="$auto_uid"
    fi
    read -r -p "UserID [$userid]: " val; userid=${val:-$userid}
    read -r -p "Notiz [$notiz]: " val; notiz=${val:-$notiz}

    jq -n --arg kundenid "$kundenid" --arg nutzername "$nutzername" \
          --arg pass "$pass" --arg autok "$autok" --arg freundschaftslink "$freundschaftslink" \
          --arg code "$code" --arg userid "$userid" --arg notiz "$notiz" \
          '{kundenid:$kundenid, nutzername:$nutzername, pass:$pass, autok:$autok, freundschaftslink:$freundschaftslink, code:$code, userid:($userid // empty), notiz:$notiz}'
}

if [ "$key" = "interneid" ]; then
    new_entry=$(update_eigene)
else
    new_entry=$(update_kunden)
fi

# Eintrag in der JSON ersetzen
if [ -n "$new_entry" ]; then
    tmp=$(mktemp)
    jq --arg sel "$selected" --arg k "$key" --argjson new "$new_entry" \
       'map(if .[$k]==$sel then $new else . end)' "$infos_file" > "$tmp" && mv "$tmp" "$infos_file"
    echo "Eintrag aktualisiert."
    if command -v termux-toast >/dev/null; then
        termux-toast "Eintrag aktualisiert"
    fi
else
    echo "Keine Änderungen vorgenommen." >&2
    if command -v termux-toast >/dev/null; then
        termux-toast "Keine Änderungen"
    fi
fi
