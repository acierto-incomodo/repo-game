[Setup]
AppName=R.E.P.O. by StormGamesStudios
AppVersion=1.0.4
DefaultDirName={userappdata}\StormGamesStudios\Programs\R.E.P.O.
DefaultGroupName=StormGamesStudios
OutputDir=C:\Users\melio\Documents\GitHub\repo\output
OutputBaseFilename=R.E.P.O._Launcher_Installer
Compression=lzma
SolidCompression=yes
AppCopyright=Copyright © 2025 StormGamesStudios. All rights reserved.
VersionInfoCompany=StormGamesStudios
AppPublisher=StormGamesStudios
SetupIconFile=repo.ico
VersionInfoVersion=1.0.4.0
DisableProgramGroupPage=yes
; Habilitar selección de carpeta
DisableDirPage=no

[Files]
Source: "C:\Users\melio\Documents\GitHub\repo\dist\installer_updater.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\melio\Documents\GitHub\repo\repo.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\melio\Documents\GitHub\repo\repo.png"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{commonprograms}\StormGamesStudios\R.E.P.O."; Filename: "{app}\installer_updater.exe"; IconFilename: "{app}\repo.ico"; Comment: "Lanzador de R.E.P.O."; WorkingDir: "{app}"
Name: "{commonprograms}\StormGamesStudios\Desinstalar R.E.P.O."; Filename: "{uninstallexe}"; IconFilename: "{app}\repo.ico"; Comment: "Desinstalar R.E.P.O."

[Registry]
Root: HKCU; Subkey: "Software\R.E.P.O."; ValueType: string; ValueName: "Install_Dir"; ValueData: "{app}"

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Run]
Filename: "{app}\installer_updater.exe"; Description: "Ejecutar R.E.P.O."; Flags: nowait postinstall skipifsilent

[Code]
procedure CloseApp();
var
  ResultCode: Integer;
begin
  // Cierra el actualizador y el launcher si están abiertos
  Exec('taskkill', '/F /IM installer_updater.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Exec('taskkill', '/F /IM win_launcher.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Exec('taskkill', '/F /IM "repo"', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  // Durante la instalación, cierra cualquier instancia abierta
  if CurStep = ssInstall then
  begin
    CloseApp();
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