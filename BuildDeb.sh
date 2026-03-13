#!/bin/bash
# build_deb.sh
# Crea un paquete .deb para Fusion Arena Launcher desde el ejecutable PyInstaller

set -e

# Configuración
PACKAGE_NAME="fusionarenalauncher"
VERSION="1.1.0"
ARCH="amd64"
EXECUTABLE_NAME="main"        # Tu binario generado por PyInstaller
ICON_NAME="icono.png"           # Icono del launcher

# Directorios del paquete
DEB_DIR="${PACKAGE_NAME}_deb"
DEBIAN_DIR="$DEB_DIR/DEBIAN"
OPT_DIR="$DEB_DIR/opt/$PACKAGE_NAME"
BIN_DIR="$DEB_DIR/usr/local/bin"
APPLICATIONS_DIR="$DEB_DIR/usr/share/applications"

# Limpiar estructura anterior
rm -rf "$DEB_DIR"

# Crear carpetas
mkdir -p "$DEBIAN_DIR"
mkdir -p "$OPT_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$APPLICATIONS_DIR"

# Archivo control
cat > "$DEBIAN_DIR/control" <<EOL
Package: $PACKAGE_NAME
Version: $VERSION
Section: games
Priority: optional
Architecture: $ARCH
Depends: python3
Maintainer: StormGamesStudios <meliodas.aitor@gmail.com>
Description: Launcher de Fusion Arena
 Un launcher para descargar y actualizar Fusion Arena automáticamente.
EOL

# Copiar ejecutable y darle permisos
cp "dist/$EXECUTABLE_NAME" "$OPT_DIR/"
chmod +x "$OPT_DIR/$EXECUTABLE_NAME"

# Copiar icono
cp "$ICON_NAME" "$OPT_DIR/"

# Crear script wrapper para ejecutar el launcher
cat > "$BIN_DIR/$PACKAGE_NAME" <<EOL
#!/bin/bash
cd /opt/$PACKAGE_NAME
./$EXECUTABLE_NAME
EOL

chmod +x "$BIN_DIR/$PACKAGE_NAME"

# Crear archivo .desktop para menú
cat > "$APPLICATIONS_DIR/$PACKAGE_NAME.desktop" <<EOL
[Desktop Entry]
Name=Fusion Arena Launcher
Comment=Launcher de Fusion Arena
Exec=/usr/local/bin/$PACKAGE_NAME
Icon=/opt/$PACKAGE_NAME/$ICON_NAME
Terminal=false
Type=Application
Categories=Game;
EOL

echo "Estructura de paquete .deb creada en '$DEB_DIR'."
echo "Ahora puedes construir el .deb con:"
echo "dpkg-deb --build $DEB_DIR"
