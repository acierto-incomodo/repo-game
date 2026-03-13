#!/bin/bash

# Array de carpetas a eliminar
folders=("build" "dist" "downloads" "game" "theshooterlauncher_deb" "snap" "WinDownloads")

# Array de archivos a eliminar
files=("main.spec" "theshooterlauncher_deb.deb" "launcher_win.spec" "installer_updater.spec" "version_win_launcher.txt")

# Eliminar carpetas si existen
for folder in "${folders[@]}"; do
    if [ -d "$folder" ]; then
        echo "Eliminando carpeta: $folder"
        rm -rf "$folder"
    else
        echo "No existe la carpeta: $folder"
    fi
done

# Eliminar archivos si existen
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "Eliminando archivo: $file"
        rm -f "$file"
    else
        echo "No existe el archivo: $file"
    fi
done

echo "Proceso completado."
