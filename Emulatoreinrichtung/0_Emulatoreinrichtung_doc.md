# Modul Emulatoreinrichtung

Hier kommen alle Skripte zusammen, die zur Vorbereitung eines frischen Emulators benötigt werden. Damit lässt sich eine Testumgebung für **Monopoly Go** schnell aufsetzen.

## Enthaltene Skripte

### check_path.sh
Legt die erforderlichen Ordner auf dem Gerät an und prüft deren Existenz.

### dl_apps.sh
Lädt alle benötigten Apps (z.B. den Emulator und Hilfstools) herunter und installiert sie automatisch.

### dl_data.sh
Lädt zusätzliche Dateien wie Konfigurationen oder Spielstände herunter und speichert sie an den richtigen Stellen.

### 1_Download.sh
Lädt benötigte Archive vom Backup-Server herunter, entpackt sie und bietet an,
die enthaltenen APK-Dateien zu installieren.
Alle benötigten Zip-Archive befinden sich unter `babixgo.de/files.babixgo.de/MoGo_backup/*.zip`.

### 2_Aendere_Ids.sh
Ändert die Android ID, die Advertising ID und den Geräte-Fingerprint automatisch.
