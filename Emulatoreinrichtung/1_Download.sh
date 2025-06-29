#!/bin/bash
set -e
# Script to download emulator setup files and install apps
BASE_DIR="/storage/emulated/0/MonopolyGo"
SERVER="babixgo.de"
USER="babixgode"
PASS="Schnaps0402"
REMOTE_DIR="files.babixgo.de/MoGo_backup"
FILES=("Anwendung*.zip" "Accoun*.zip" "Scri*.zip")

if command -v termux-toast >/dev/null; then
    termux-toast "Prüfe Verzeichnis"
fi

if [ ! -d "$BASE_DIR" ]; then
    mkdir -p "$BASE_DIR"
fi

if command -v termux-toast >/dev/null; then
    termux-toast "Lade Dateien herunter"
fi

if ! command -v sshpass >/dev/null; then
    echo "sshpass wird benötigt" >&2
    exit 1
fi

sshpass -p "$PASS" sftp -oBatchMode=no ${USER}@${SERVER} <<SFTP
cd "$REMOTE_DIR"
lcd "$BASE_DIR"
get ${FILES[0]}
get ${FILES[1]}
get ${FILES[2]}
bye
SFTP

for file in "${FILES[@]}"; do
    unzip -o "$BASE_DIR/$file" -d "$BASE_DIR"
done

APP_DIR="$BASE_DIR/Anwendungen"
if [ -d "$APP_DIR" ]; then
    find "$APP_DIR" -type f -name "*.apk" | while read -r apk; do
        read -r -p "Installiere $(basename "$apk")? [j/N] " ans
        if [[ $ans =~ ^[Jj]$ ]]; then
            pm install -r "$apk"
        fi
    done
fi

if command -v termux-toast >/dev/null; then
    termux-toast "Download fertig"
fi
