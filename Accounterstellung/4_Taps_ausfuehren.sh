#!/bin/bash
set -e

# Führt die Taps zum Tutorial aus
if command -v termux-toast >/dev/null; then
    termux-toast "Führe Taps aus"
fi

vp1=192.168.0.25:6556
vp2=192.168.0.25:6557
vp3=192.168.0.25:6558
DEVICES=($vp1 $vp2 $vp3)

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

sleep 15

for i in "${!TAPS[@]}"; do
    tap="${TAPS[$i]}"
    pause_cmd="${Pauses[$i]}"
    for DEVICE in "${DEVICES[@]}"; do
        adb -s "$DEVICE" shell input tap $tap
        eval $pause_cmd
    done
done

if command -v termux-toast >/dev/null; then
    termux-toast "Taps abgeschlossen"
fi
