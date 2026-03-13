#!/usr/bin/env python3
import os
import glob
import subprocess
from pathlib import Path

def find_and_run_uninstaller():
    """
    Busca y ejecuta desinstaladores de versiones antiguas en la carpeta de AppData.
    """
    # 1. Obtener la ruta a %APPDATA%
    appdata_path = os.getenv('APPDATA')
    if not appdata_path:
        print("No se pudo encontrar la variable de entorno APPDATA.")
        return

    # 2. Construir la ruta completa a la carpeta del launcher antiguo
    old_launcher_dir = Path(appdata_path) / "StormGamesStudios" / "NewGameDir" / "REPO_Launcher"

    print(f"Buscando desinstalador antiguo en: {old_launcher_dir}")

    # 3. Comprobar si la carpeta existe
    if not old_launcher_dir.is_dir():
        print("La carpeta del launcher antiguo no existe. No hay nada que hacer.")
        return

    # 4. Buscar archivos unins*.exe (ej: unins000.exe)
    uninstaller_pattern = old_launcher_dir / "unins*.exe"
    uninstallers = glob.glob(str(uninstaller_pattern))

    # 5. Si no se encuentran, no hacer nada.
    if not uninstallers:
        print("No se encontró ningún desinstalador antiguo.")
        return

    # 6. Si se encuentra, ejecutarlo de forma silenciosa.
    for uninstaller_path in uninstallers:
        print(f"Ejecutando desinstalador antiguo: {uninstaller_path}")
        try:
            subprocess.run([uninstaller_path, '/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART'], check=True)
            print(f"El desinstalador {os.path.basename(uninstaller_path)} se ejecutó.")
        except Exception as e:
            print(f"Ocurrió un error al ejecutar el desinstalador: {e}")

if __name__ == "__main__":
    find_and_run_uninstaller()
    print("\nProceso completado.")