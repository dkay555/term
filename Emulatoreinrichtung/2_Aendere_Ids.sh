#!/bin/bash
set -e
# Randomize Android ID, advertising ID and device fingerprint
if command -v termux-toast >/dev/null; then
    termux-toast "Ändere Geräte-IDs"
fi

rand_id=$(openssl rand -hex 8)

if [ "$(id -u)" -ne 0 ]; then
    SUDO="su -c"
else
    SUDO=""
fi

$SUDO settings put secure android_id "$rand_id"

# Advertising ID wird durch Zurücksetzen der Google Play Services generiert
$SUDO pm clear com.google.android.gms >/dev/null 2>&1 || true

new_fp="generic/${rand_id}/user/release-keys"
if $SUDO command -v resetprop >/dev/null 2>&1; then
    $SUDO resetprop ro.build.fingerprint "$new_fp"
else
    $SUDO setprop ro.build.fingerprint "$new_fp" || true
fi

if command -v termux-toast >/dev/null; then
    termux-toast "IDs geändert"
fi
