#!/bin/bash

# Ejecutar Clear.sh
if [ -f "./Clear.sh" ]; then
    bash ./Clear.sh
    echo "Clear.sh ejecutado correctamente."
else
    echo "Clear.sh no encontrado."
fi

# Ejecutar BuildLinux.sh
if [ -f "./BuildLinux.sh" ]; then
    bash ./BuildLinux.sh
    echo "BuildLinux.sh ejecutado correctamente."
else
    echo "BuildLinux.sh no encontrado."
fi

# Copiar y dar permisos al ejecutable
if [ -f "dist/main" ]; then
    cp dist/main ./main
    chmod +x main
    echo "Ejecutable copiado y permisos aplicados."
else
    echo "dist/main no encontrado."
fi

# Ejecutar snapcraft
snapcraft
echo "Snapcraft ejecutado correctamente."

echo "Todos los scripts se han ejecutado."
