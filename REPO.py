import sys
import os
import requests
from threading import Thread
from PySide6.QtWidgets import QApplication, QWidget, QVBoxLayout, QLabel, QProgressBar, QMessageBox
from PySide6.QtCore import Qt, Signal, Slot
from PySide6.QtGui import QIcon

# --- Helper para encontrar recursos ---
# Determina la ruta base para que funcione tanto en desarrollo como empaquetado con PyInstaller
if getattr(sys, 'frozen', False):
    # Si la aplicación está "congelada" (empaquetada)
    basedir = sys._MEIPASS
else:
    # Si se está ejecutando como un script normal
    basedir = os.path.dirname(os.path.abspath(__file__))

# Configuración: URL y nombre del archivo destino
URL_ARCHIVO = "https://github.com/acierto-incomodo/repo-game/releases/latest/download/REPO_Launcher_Installer.exe"
NOMBRE_ARCHIVO = "REPO_Launcher_Installer.exe"

class LauncherWin(QWidget):
    # Señales para comunicar el hilo de descarga con la interfaz gráfica
    update_progress = Signal(int)
    download_finished = Signal()
    show_error = Signal(str)

    def __init__(self):
        super().__init__()
        self.setWindowTitle("Instalador Global del Launcher")
        self.setWindowIcon(QIcon(os.path.join(basedir, "download-icon.png")))
        self.setFixedSize(300, 100)
        self.setWindowFlags(Qt.Window | Qt.WindowMinimizeButtonHint | Qt.WindowCloseButtonHint)
        
        # Configuración de la interfaz
        layout = QVBoxLayout()
        self.label = QLabel("Iniciando descarga...", alignment=Qt.AlignCenter)
        layout.addWidget(self.label)

        self.progress = QProgressBar()
        self.progress.setValue(0)
        layout.addWidget(self.progress)
        self.setLayout(layout)

        # Conectar señales a sus funciones (Slots)
        self.update_progress.connect(self.set_progress)
        self.download_finished.connect(self.run_file)
        self.show_error.connect(self.on_error)

        # Iniciar la descarga automáticamente en un hilo separado
        Thread(target=self.download_worker, daemon=True).start()

    def download_worker(self):
        try:
            response = requests.get(URL_ARCHIVO, stream=True, timeout=60)
            response.raise_for_status()
            
            total_size = int(response.headers.get('content-length', 0))
            downloaded = 0

            with open(NOMBRE_ARCHIVO, "wb") as f:
                for chunk in response.iter_content(chunk_size=8192):
                    if chunk:
                        f.write(chunk)
                        downloaded += len(chunk)
                        if total_size > 0:
                            percent = int((downloaded / total_size) * 100)
                            self.update_progress.emit(percent)

            self.download_finished.emit()

        except Exception as e:
            self.show_error.emit(str(e))

    @Slot(int)
    def set_progress(self, value):
        self.progress.setValue(value)
        self.label.setText(f"Descargando: {value}%")
        self.label.setText(f"Actualización Obligatoria")

    @Slot()
    def run_file(self):
        self.label.setText("Ejecutando...")
        try:
            os.startfile(NOMBRE_ARCHIVO)
            QApplication.quit()
        except Exception as e:
            self.on_error(f"Error al ejecutar: {e}")

    @Slot(str)
    def on_error(self, msg):
        QMessageBox.critical(self, "Error", msg)
        self.close()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = LauncherWin()
    window.show()
    sys.exit(app.exec())