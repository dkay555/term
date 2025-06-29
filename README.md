# Tasker-Skripte zur Verwaltung von Monopoly Go Accounts

Dieses Repository enthält Bash-Skripte für [Tasker](https://tasker.joaoapps.com/) oder Termux auf Android-Geräten. Sie helfen dabei, Spielstände von **Monopoly Go** zu sichern, wiederherzustellen und zwischen mehreren Accounts zu wechseln.

## Ziel
Die Skripte automatisieren wiederkehrende Aufgaben wie Backup, Restore und Bearbeitung der Benutzerdaten. Sie benötigen Root-Rechte, um auf die Dateien unter `/data/data` zugreifen zu können.

## Nutzung
1. Klone oder kopiere das Repository auf dein Android-Gerät.
2. Führe `Accountverwaltung/1_Account_wiederherstellen.sh` mit Root-Rechten aus, um einen Account einzuspielen.
3. Mit `Accountverwaltung/2_Eigener_Account_sichern.sh` sicherst du den aktuell aktiven Account. Das Skript fragt nach einer internen ID und optionaler Notiz, liest deine UserID aus und erstellt einen Einladungslink. Die Dateien landen unter `Accounts/Eigene/<ID>/`, Metadaten in `Accounts/Eigene/Accountinfos.csv`.
4. `Accountverwaltung/2_Kunden_Account_sichern.sh` speichert Kundenaccounts. Dabei wird aus dem angegebenen Freundschaftslink die UserID ermittelt. Bei Bedarf kopiert das Skript auch die Accountdateien nach `Accounts/Kunden/<KundenID>/`.
5. Aktualisiere gespeicherte Infos mit `Accountverwaltung/3_Infos_bearbeiten.sh`. Es listet alle Einträge und lässt sie ändern.
6. `Accountverwaltung/4_Kopiere_Links.sh` kopiert einen oder mehrere Einladungslinks deiner gesicherten Accounts in die Zwischenablage.
7. Mit `Accountverwaltung/5_Backup_und_restore.sh` archivierst du den gesamten Ordner `Accounts` und lädst das Archiv auf deinen Backup-Server oder stellst das letzte Backup wieder her. Existiert kein SSH-Key, wird automatisch einer erstellt und auf dem Server hinterlegt.
8. Starte `Emulatoreinrichtung/Emulatoreinrichtung.sh`, um einen frischen Emulator einzurichten. Die benötigten Archive liegen unter `babixgo.de/files.babixgo.de/MoGo_backup/*.zip` bereit.

Stelle sicher, dass deine Backups unter folgenden Pfaden liegen:
- `/storage/emulated/0/MonopolyGo/Accounts/Eigene/`
- `/storage/emulated/0/MonopolyGo/Accounts/Kunden/`

Diese Ordner müssen existieren und jeweils Unterordner für jeden gespeicherten Account besitzen.

## Voraussetzungen
- Gerootetes Android-Gerät (zum Kopieren der App-Daten)
- Bash-Shell über Termux oder eine andere Umgebung
- Die Android-Utilities `am` und `monkey`
- Das Paket `sshpass` für automatisierte SFTP-Transfers
- Das Programm `unzip` zum Entpacken der Archive
- Das Paket `openssl` zum Erzeugen zufälliger IDs

## Bash-Optionen
Alle Skripte verwenden direkt nach der Shebang-Zeile `set -e`. Dadurch bricht das Skript sofort ab, wenn ein Befehl fehlschlägt.

## Geplante Funktionen
In [Übersicht.md](Übersicht.md) findest du Ideen und Aufgaben für zukünftige Skripte rund um Backup, Restore und Informationsverwaltung.

## Lizenz
Dieses Projekt steht unter der MIT-Lizenz. Siehe [LICENSE](LICENSE) für weitere Informationen.
