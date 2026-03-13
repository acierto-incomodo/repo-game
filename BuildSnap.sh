#!/bin/bash

# Crear carpeta snap
mkdir -p snap/gui
mkdir -p snap/local

# Crear snapcraft.yaml
cat << 'EOF' > snap/snapcraft.yaml
name: theshooterlauncher
base: core22
version: '1.1.0'
summary: Launcher oficial del juego Fusion Arena
description: >
  Launcher que permite instalar, actualizar e iniciar Fusion Arena.
  Compatible con Windows y Linux desde un único instalador.

grade: stable
confinement: devmode

apps:
  theshooterlauncher:
    command: bin/theshooterlauncher
    desktop: theshooterlauncher.desktop
    plugs:
      - desktop
      - desktop-legacy
      - x11

parts:
  launcher:
    plugin: dump
    source: snap
    organize:
      local/theshooterlauncher: bin/theshooterlauncher
    override-build: |
      snapcraftctl build
      # Copiar launcher.desktop desde gui
      install -Dm644 gui/theshooterlauncher.desktop $SNAPCRAFT_PART_INSTALL/meta/gui/theshooterlauncher.desktop
      # Copiar icono desde local
      install -Dm644 local/logo.png $SNAPCRAFT_PART_INSTALL/meta/gui/icon.png

icon: snap/local/logo.png
EOF

# Crear el archivo launcher.desktop
cat << 'EOF' > snap/gui/theshooterlauncher.desktop
[Desktop Entry]
Name=Fusion Arena Launcher
Exec=theshooterlauncher
Icon=${SNAP}/logo.png
Type=Application
Categories=Game;
Terminal=false
EOF

# Copiar logo.png desde raíz
if [ -f logo.png ]; then
    cp logo.png snap/local
    echo "logo.png copiado correctamente."
else
    echo "ADVERTENCIA: No se encontró logo.png en root."
fi

# Copiar main desde dist/
if [ -f dist/main ]; then
    cp dist/main snap/local/theshooterlauncher
    echo "main copiado desde dist/."
else
    echo "ADVERTENCIA: No se encontró dist/main."
fi

echo "Estructura del snap creada correctamente."

snapcraft pack