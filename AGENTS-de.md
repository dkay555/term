# Richtlinien für dieses Repository

- Module sollen autark funktionieren. Jedes Unterverzeichnis stellt ein eigenes Modul dar.
- Neue Module gehören in einen eigenen Unterordner.
- Gemeinsame JSON-Daten sollten möglichst nicht doppelt abgelegt werden.
- Skripte tragen die Namenskonvention `Nr_Skriptname.sh` (z.B. `1_Setup.sh`), um die Ausführungsreihenfolge klar zu machen.

## Regeln
1. JSON-Dateien dürfen nur mit `jq` gelesen oder geschrieben werden.
2. Jedes Skript muss einzeln mit `bash Skriptname.sh` startbar sein.
