#!/bin/bash
set -e

# Sichere die Accountdaten und lade sie hoch
if command -v termux-toast >/dev/null; then
    termux-toast "Sichere Daten"
fi

vp1=192.168.0.25:6556
vp2=192.168.0.25:6557
vp3=192.168.0.25:6558
DEVICES=($vp1 $vp2 $vp3)

SHARE_DIRS=(
  "/dev/share/MGo1"
  "/dev/share/MGo2"
  "/dev/share/MGo3"
)

PACKAGE_NAME="com.scopely.monopolygo"
SOURCE_DIR="/data/data/com.scopely.monopolygo/files"

FTP_SERVER="example.com"
FTP_USER="user"
FTP_PASS="pass"
REMOTE_DIR="/upload"

for index in "${!DEVICES[@]}"; do
    DEVICE=${DEVICES[$index]}
    TARGET_DIR=${SHARE_DIRS[$index]}
    adb -s "$DEVICE" shell am force-stop $PACKAGE_NAME
    sleep 2
    adb -s "$DEVICE" shell monkey -p $PACKAGE_NAME -c android.intent.category.LAUNCHER 1
    sleep 3
    adb -s "$DEVICE" shell "su -c 'cp -r $SOURCE_DIR $TARGET_DIR/files'"

    if command -v sshpass >/dev/null; then
        sshpass -p "$FTP_PASS" sftp -oBatchMode=no ${FTP_USER}@${FTP_SERVER} <<SFTP
cd $REMOTE_DIR
put -r $TARGET_DIR/files
bye
SFTP
    fi
    sleep 3
    echo "Daten von $DEVICE hochgeladen"
done

if command -v termux-toast >/dev/null; then
    termux-toast "Daten sichern abgeschlossen"
fi
