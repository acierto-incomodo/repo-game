Clear.ps1
cp main.py Launcher_Portable.py
cp main.py launcher_win.py
python -m PyInstaller --onefile --windowed --noconsole --icon=download-icon.ico --add-data "download-icon.png:." "Lethal Company.py"
python -m PyInstaller --onefile --windowed --noconsole --icon=repo.ico Launcher_Portable.py
python -m PyInstaller --onefile --windowed --noconsole --icon=repo.ico launcher_win.py
python -m PyInstaller --onefile --windowed --noconsole --icon=repo.ico installer_updater.py
python -m PyInstaller --onefile --windowed --noconsole --icon=repo.ico uninstaller-old.py
echo 1.0.2 > version_win_launcher.txt