[Setup]
AppName=Fusion Arena Launcher by StormGamesStudios
AppVersion=1.0.5
DefaultDirName={userappdata}\StormGamesStudios\NewGameDir\TheShooterLauncher_New
DefaultGroupName=StormGamesStudios
OutputDir=C:\Users\melio\Documents\GitHub\TheShooter\output
OutputBaseFilename=Fusion_Arena_Launcher_Installer
Compression=lzma
SolidCompression=yes
AppCopyright=Copyright © 2025 StormGamesStudios. All rights reserved.
VersionInfoCompany=StormGamesStudios
AppPublisher=StormGamesStudios
SetupIconFile=icono.ico
VersionInfoVersion=1.0.5.0
DisableDirPage=yes
DisableProgramGroupPage=yes

[Files]
; Archivos del lanzador
Source: "C:\Users\melio\Documents\GitHub\TheShooter\dist\installer_updater.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\melio\Documents\GitHub\TheShooter\icono.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\melio\Documents\GitHub\TheShooter\icono.png"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
; Acceso directo en el escritorio
Name: "{userdesktop}\Fusion Arena Launcher"; Filename: "{app}\installer_updater.exe"; IconFilename: "{app}\icono.ico"

; Acceso directo en el menú de inicio dentro de la carpeta StormLauncher_HMCL-Edition
Name: "{commonprograms}\StormGamesStudios\Fusion Arena Launcher"; Filename: "{app}\installer_updater.exe"; IconFilename: "{app}\icono.ico"
Name: "{commonprograms}\StormGamesStudios\Desinstalar Fusion Arena Launcher"; Filename: "{uninstallexe}"; IconFilename: "{app}\icono.ico"

[Registry]
; Guardar ruta de instalación para poder desinstalar
Root: HKCU; Subkey: "Software\Fusion Arena Launcher"; ValueType: string; ValueName: "Install_Dir"; ValueData: "{app}"

[UninstallDelete]
; Eliminar carpeta del appdata y acceso directo
Type: filesandordirs; Name: "{app}"

[Run]
; Ejecutar el lanzador después de la instalación
Filename: "{app}\installer_updater.exe"; Description: "Ejecutar Fusion Arena Launcher"; Flags: nowait postinstall skipifsilent

[Code]
var
  UninstallRunOnce: Boolean;

function InitializeSetup(): Boolean;
begin
  Result := True;
  UninstallRunOnce := False; // no se ha corrido aún
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
  UninstallPath: String;
  FindRec: TFindRec;
begin
  // Cuando comienza la instalación real (después de pulsar "Instalar"),
  // intentamos ejecutar el desinstalador previo si no lo hicimos ya.
  if (CurStep = ssInstall) and not UninstallRunOnce then
  begin
    UninstallRunOnce := True;
    UninstallPath := ExpandConstant('{userappdata}\StormGamesStudios\NewGameDir\TheShooterLauncher_New');
    if DirExists(UninstallPath) then
    begin
      if FindFirst(UninstallPath + '\unins*.exe', FindRec) then
      begin
        try
          Exec(UninstallPath + '\' + FindRec.Name,
               '/SILENT /VERYSILENT /SUPPRESSMSGBOXES',
               '', SW_SHOW, ewWaitUntilTerminated, ResultCode);
        finally
          FindClose(FindRec);
        end;
      end;
    end;
  end;
end;
