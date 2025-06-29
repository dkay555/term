#!/bin/bash
set -e

# Accounterstellung ohne adb direkt auf dem Gerät

if command -v termux-toast >/dev/null; then
    termux-toast "Starte Accounterstellung (lokal)"
fi

APK_PATH="/storage/emulated/0/MonopolyGo/ELITE_vE1.*.apk"
APK_TMP="/data/local/tmp/ELITE_vE1.*.apk"
PACKAGE_NAME="com.scopely.monopolygo"
SOURCE_DIR="/data/data/com.scopely.monopolygo/files"
TARGET_DIR="/storage/emulated/0/MonopolyGo/NeuerAccount"

# Koordinaten
tab1="700 1800"
tab2="700 2600"
tab3="700 2900"

TAPS=(
    "$tab1" "700 2380" "700 2200" "700 2650" "700 2250"
    "700 1000" "700 2850" "$tab1" "$tab1" "1000 2600"
    "1000 2600" "$tab1" "$tab1" "$tab1" "700 3030"
    "$tab1" "$tab1" "700 1600" "$tab2" "$tab2"
    "$tab1" "$tab1" "$tab1" "$tab1" "300 2000"
    "$tab1" "$tab3" "$tab3" "$tab3" "$tab3"
    "$tab2" "$tab2" "$tab2" "$tab2" "$tab1"
    "230 1600" "570 1600" "830 1600" "1200 1600"
    "230 2100" "570 2100" "830 2100" "1200 2100"
    "$tab3" "$tab1"
)

pa05="sleep 0.5"
pa1="sleep 1"
pa15="sleep 1.5"
pa2="sleep 2"
pa3="sleep 3"
pa4="sleep 4"

Pauses=(
  "$pa1" "$pa1" "$pa1" "$pa1" "$pa2" "$pa1" "$pa1" "$pa1" "$pa1" "$pa1"
  "$pa2" "$pa1" "$pa1" "$pa1" "$pa1" "$pa1" "$pa1" "$pa1" "$pa2" "$pa3"
  "$pa15" "$pa15" "$pa15" "$pa15" "$pa15" "$pa15" "$pa15" "$pa15" "$pa15" "$pa15"
  "$pa2" "$pa2" "$pa2" "$pa2" "$pa4"
  "$pa05" "$pa05" "$pa05" "$pa05" "$pa05" "$pa05" "$pa05" "$pa05"
  "$pa3" "$pa2"
)

# Vorbereitung
cp $APK_PATH $APK_TMP
pm install -g $APK_TMP
monkey -p $PACKAGE_NAME -c android.intent.category.LAUNCHER 1

sleep 15

for i in "${!TAPS[@]}"; do
    input tap ${TAPS[$i]}
    eval ${Pauses[$i]}
done

am force-stop $PACKAGE_NAME
sleep 2
monkey -p $PACKAGE_NAME -c android.intent.category.LAUNCHER 1
sleep 3
su -c "cp -r $SOURCE_DIR $TARGET_DIR"

if command -v termux-toast >/dev/null; then
    termux-toast "Accounterstellung abgeschlossen"
fi
