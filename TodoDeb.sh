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

# Ejecutar BuildDeb.sh
if [ -f "./BuildDeb.sh" ]; then
    bash ./BuildDeb.sh
    echo "BuildDeb.sh ejecutado correctamente."
else
    echo "BuildDeb.sh no encontrado."
fi

# Ejecutar CreateDeb.sh
if [ -f "./CreateDeb.sh" ]; then
    bash ./CreateDeb.sh
    echo "CreateDeb.sh ejecutado correctamente."
else
    echo "CreateDeb.sh no encontrado."
fi

echo "Todos los scripts se han ejecutado."
