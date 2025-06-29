# Repository Guidelines

- Modules should run independently. Each folder under the repository root represents a self-contained module.
- Place new modules in their own subdirectory.
- Use Termux-toast tobinform the user during the script is running. 
- Avoid duplicating shared JSON data across modules.
- Each module should provide a master script named after the module (e.g. `Accountverwaltung.sh`) that uses a case statement to call the numbered scripts.
- Script files follow the naming convention `Nr_Skriptname.sh` (for example `1_Setup.sh`). This defines the order of execution.
- Document all dependencies in `README.md` under the "Voraussetzungen" section:
  - A rooted Android device (for copying app data)
  - A Bash shell via Termux or another environment
  - The Android utilities `am` and `monkey`

## Rules

1. Read or write .csv files 
2. Every script must be executable on its own with `bash Skriptname.sh`.
