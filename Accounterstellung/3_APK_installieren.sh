#!/bin/bash
set -e

# Installiere APK auf allen verbundenen Geräten
if command -v termux-toast >/dev/null; then
    termux-toast "Installiere APK"
fi

vp1=192.168.0.25:6556
vp2=192.168.0.25:6557
vp3=192.168.0.25:6558
DEVICES=($vp1 $vp2 $vp3)

APK_PATH="/storage/emulated/0/MonopolyGo/ELITE_vE1.*.apk"
APK_TMP="/data/local/tmp/ELITE_vE1.*.apk"
PACKAGE_NAME="com.scopely.monopolygo"

for DEVICE in "${DEVICES[@]}"; do
    adb -s "$DEVICE" push $APK_PATH $APK_TMP
    adb -s "$DEVICE" shell pm install -g $APK_TMP
    adb -s "$DEVICE" shell monkey -p $PACKAGE_NAME -c android.intent.category.LAUNCHER 1
    sleep 10
done

if command -v termux-toast >/dev/null; then
    termux-toast "APK installiert"
fi
