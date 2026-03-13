[Setup]
AppName=R.E.P.O. Launcher by StormGamesStudios
AppVersion=1.0.6
DefaultDirName={userappdata}\StormGamesStudios\NewGameDir\repo-game
DefaultGroupName=StormGamesStudios
OutputDir=C:\Users\melio\Documents\GitHub\repo-game\output
OutputBaseFilename=REPO_Launcher_Installer
Compression=lzma
SolidCompression=yes
AppCopyright=Copyright © 2025 StormGamesStudios. All rights reserved.
VersionInfoCompany=StormGamesStudios
AppPublisher=StormGamesStudios
SetupIconFile=repo.ico
VersionInfoVersion=1.0.6.0
DisableProgramGroupPage=yes
; Habilitar selección de carpeta
DisableDirPage=yes
UsePreviousAppDir=no

[Files]
Source: "C:\Users\melio\Documents\GitHub\repo-game\dist\installer_updater.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\melio\Documents\GitHub\repo-game\repo.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\melio\Documents\GitHub\repo-game\repo.png"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\melio\Documents\GitHub\repo-game\dist\uninstaller-old.exe"; DestDir: "{tmp}"; Flags: dontcopy

[Icons]
Name: "{commonprograms}\StormGamesStudios\R.E.P.O. Launcher"; Filename: "{app}\installer_updater.exe"; IconFilename: "{app}\repo.ico"; Comment: "Lanzador de R.E.P.O. Launcher"; WorkingDir: "{app}"
Name: "{commonprograms}\StormGamesStudios\Desinstalar R.E.P.O. Launcher"; Filename: "{uninstallexe}"; IconFilename: "{app}\repo.ico"; Comment: "Desinstalar R.E.P.O. Launcher"

; Acceso directo en el menú de inicio dentro de la carpeta StormLauncher_HMCL-Edition
Name: "{commonprograms}\StormGamesStudios\R.E.P.O. Launcher"; Filename: "{app}\installer_updater.exe"; IconFilename: "{app}\repo.ico"
Name: "{commonprograms}\StormGamesStudios\Desinstalar R.E.P.O. Launcher"; Filename: "{uninstallexe}"; IconFilename: "{app}\repo.ico"

[Registry]
Root: HKCU; Subkey: "Software\R.E.P.O. Launcher"; ValueType: string; ValueName: "Install_Dir"; ValueData: "{app}"

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Run]
Filename: "{app}\installer_updater.exe"; Description: "Ejecutar R.E.P.O. Launcher"; Flags: nowait postinstall skipifsilent

[Code]
function IsDirectoryEmpty(DirPath: String): Boolean;
var
  FindRec: TFindRec;
begin
  Result := True;
  if DirExists(DirPath) then
  begin
    if FindFirst(DirPath + '\*', FindRec) then
    begin
      try
        repeat
          if (FindRec.Name <> '.') and (FindRec.Name <> '..') then
          begin
            Result := False;
            Break;
          end;
        until not FindNext(FindRec);
      finally
        FindClose(FindRec);
      end;
    end;
  end;
end;

procedure RunUninstaller(DirPath: String);
var
  FindRec: TFindRec;
  ResultCode: Integer;
  Attempts: Integer;
begin
  if DirExists(DirPath) then
  begin
    // Busca cualquier archivo que coincida con unins*.exe (unins000.exe, unins001.exe, etc.)
    if FindFirst(DirPath + '\unins*.exe', FindRec) then
    begin
      try
        repeat
          // Ejecutar el desinstalador de forma muy silenciosa y esperar a que termine
          Exec(DirPath + '\' + FindRec.Name, '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
        until not FindNext(FindRec);
      finally
        FindClose(FindRec);
      end;
    end;

    // Esperar hasta que la carpeta esté vacía (máximo 5 segundos de espera activa)
    Attempts := 0;
    while (not IsDirectoryEmpty(DirPath)) and (Attempts < 10) do
    begin
      Sleep(500); // Esperar 500ms antes de volver a comprobar
      Attempts := Attempts + 1;
      
      // Intentar borrar lo que quede (por si son archivos de log o restos que el desinstalador no quitó)
      if Attempts > 5 then
      begin
        DelTree(DirPath, True, True, True);
      end;
    end;
  end;
end;

procedure CloseApp();
var
  ResultCode: Integer;
begin
  // Cierra el actualizador y el launcher si están abiertos
  Exec('taskkill', '/F /IM Launcher_Portable.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Exec('taskkill', '/F /IM win_launcher.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Exec('taskkill', '/F /IM "R.E.P.O. Launcher.exe"', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Exec('taskkill', '/F /IM "Launcher_Portable.exe"', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Exec('taskkill', '/F /IM "REPO.exe"', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
begin
  // Durante la instalación, cierra cualquier instancia abierta
  if CurStep = ssInstall then
  begin
    CloseApp();

    // Extraer y ejecutar el uninstaller-old.exe temporalmente
    ExtractTemporaryFile('uninstaller-old.exe');
    Exec(ExpandConstant('{tmp}\uninstaller-old.exe'), '', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  // Durante la desinstalación, cierra cualquier instancia abierta
  if CurUninstallStep = usUninstall then
  begin
    CloseApp();
  end;
end;