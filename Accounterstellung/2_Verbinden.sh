#!/bin/bash
set -e

# Verbinde Geräte über ADB
if command -v termux-toast >/dev/null; then
    termux-toast "Verbinde Geräte"
fi

vp1=192.168.0.25:6556
vp2=192.168.0.25:6557
vp3=192.168.0.25:6558
DEVICES=($vp1 $vp2 $vp3)

for DEVICE in "${DEVICES[@]}"; do
    adb connect "$DEVICE"
done

if command -v termux-toast >/dev/null; then
    termux-toast "Verbindung hergestellt"
fi
