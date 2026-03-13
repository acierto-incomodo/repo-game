Clear.bat
cp main.py Launcher_Portable.py
python -m PyInstaller --onefile --windowed --noconsole --icon=download-icon.ico --add-data "download-icon.png:." launcher_win.py
python -m PyInstaller --onefile --windowed --noconsole --icon=repo.ico Fusion_Arena_Launcher_Portable.py
python -m PyInstaller --onefile --windowed --noconsole --icon=repo.ico REPO.py
python -m PyInstaller --onefile --windowed --noconsole --icon=repo.ico uninstaller-old.py
echo 1.0.0 > version_win_launcher.txt