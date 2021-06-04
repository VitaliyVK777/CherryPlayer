#pragma include __INCLUDE__ + ";" + ReadReg(HKLM, "Software\Mitrich Software\Inno Download Plugin", "InstallDir")

#define MyAppName "CherryPlayer"
#define MyAppVersion "3.3.0"
#define MyAppX64

#ifndef UNICODE
  #error Use the Unicode Inno Setup
#endif

;#define MyAppPortable
#ifdef MyAppPortable
  #define MyAppExeUrl "http://download.cherryplayer.com/portable/3_3_0/CherryPlayer.exe"
#else
  #define MyAppExeUrl "http://download.cherryplayer.com/usual/3_3_0/CherryPlayer.exe"
#endif
#define MyAppExeName MyAppName + ".exe"
#ifdef MyAppX64
  #define MyAppFiles "files\x64\"
#else
  #define MyAppFiles "files\x86\"
#endif
#define MyLangFiles "..\languages\"

#define MyAppPublisher "CherryPlayer"
#define MyAppURL       "https://www.cherryplayer.com/"
#define MyAppContact   "support@cherryplayer.com"
#define MyAppMutex     "CherryPlayer_273f2a87-1ac8-42b7-9114-8f71db3f5d73"
#define MySetupMutex   "CherryPlayer_Setup_273f2a87-1ac8-42b7-9114-8f71db3f5d73"

#ifdef MyAppPortable
  #define MyOutputFilename MyAppName + "_portable-" + MyAppVersion + "-setup"
#else
  #define MyOutputFilename MyAppName + "-" + MyAppVersion + "-setup"
#endif

[Setup]
SignTool=signtool
AppId={{474A4782-83D9-4DD7-A214-78A38F89CD7D}
AppMutex={#MyAppMutex}
SetupMutex={#MySetupMutex}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
AppContact={#MyAppContact}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=license\license.rtf
#ifdef MyAppX64
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
#endif
#ifdef MyAppPortable
; run in non administrative install mode (install for current user only.)
PrivilegesRequired=lowest
#else
PrivilegesRequiredOverridesAllowed=dialog
#endif
OutputDir=output
OutputBaseFilename={#MyOutputFilename}
SetupIconFile=icon\CherryPlayer.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
WizardImageFile=wizard\leftbar.bmp
WizardSmallImageFile=wizard\logo.bmp
UninstallDisplayIcon={app}\{#MyAppExeName}
UsePreviousTasks=no

#include <idp.iss>

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "armenian"; MessagesFile: "compiler:Languages\Armenian.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "corsican"; MessagesFile: "compiler:Languages\Corsican.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "icelandic"; MessagesFile: "compiler:Languages\Icelandic.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "{tmp}\{#MyAppExeName}";     DestDir: "{app}"; Flags: ignoreversion external
Source: "{#MyAppFiles}*";            DestDir: "{app}"; Flags: ignoreversion recursesubdirs
Source: "{#MyLangFiles}*";           DestDir: "{app}"; Flags: ignoreversion recursesubdirs

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}";  Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[CustomMessages]
InstallingVC2019redist=Installing Microsoft Visual C++ 2019 Redistributable Package

[Run]
#ifdef MyAppX64
Filename: "{tmp}\vc_redist.x64.exe"; StatusMsg: "{cm:InstallingVC2019redist}"; Parameters: "/q /norestart"; Flags: skipifdoesntexist waituntilterminated
#else
Filename: "{tmp}\vc_redist.x86.exe"; StatusMsg: "{cm:InstallingVC2019redist}"; Parameters: "/q /norestart"; Flags: skipifdoesntexist waituntilterminated
#endif
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
var
  DonateLabel: TNewStaticText;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpFinished then begin
    with DonateLabel do
    begin
      Parent  := WizardForm.FinishedPage;
      Left    := WizardForm.FinishedLabel.Left;
      Top     := WizardForm.RunList.Top + ScaleY(35);
      Height  := ScaleY(Height);
      Caption := 'CherryPlayer is free mediaplayer. Keep it alive with donation to WakeNet.';
    end;
  end;
end;

function VC2019RedistNeedsInstall: Boolean;
var
  Key:     String;
  Install: Cardinal;
  Version: String;
begin
  Result := True;
  Key := 'SOFTWARE\Microsoft\DevDiv\VC\Servicing\14.0\RuntimeMinimum';
  if IsWin64 then begin
    Key := 'SOFTWARE\Wow6432Node\Microsoft\DevDiv\VC\Servicing\14.0\RuntimeMinimum';
  end;

  //if (RegQueryDWordValue (HKEY_LOCAL_MACHINE, Key, 'Install', Install) and
  //    RegQueryStringValue(HKEY_LOCAL_MACHINE, Key, 'Version', Version)) then
  //begin
  //  if Install = 1 then begin
  //    Result := SameStr(Copy(Version, 0, 4), '14.0');
  //  end;
  //end;
end;

procedure InitializeWizard;
begin
  DonateLabel := TNewStaticText.Create(WizardForm);

  idpDownloadAfter(wpReady);
  idpAddFile('{#MyAppExeUrl}', ExpandConstant('{tmp}\{#MyAppExeName}'));
  if VC2019RedistNeedsInstall then begin
#ifdef MyAppX64
    idpAddFile('https://aka.ms/vs/16/release/vc_redist.x64.exe', ExpandConstant('{tmp}\vc_redist.x64.exe'));
#else
    idpAddFile('https://aka.ms/vs/16/release/vc_redist.x86.exe', ExpandConstant('{tmp}\vc_redist.x86.exe'));
#endif
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ErrCode: integer;
begin
  if (CurStep = ssDone) then begin
    ShellExec('open', 'https://api.cherryplayer.com/donate.php', '', '', SW_SHOW, ewNoWait, ErrCode);
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  ErrCode: integer;
begin
  if (CurUninstallStep = usDone) then begin
    ShellExec('open', 'https://www.cherryplayer.com/contact-us', '', '', SW_SHOW, ewNoWait, ErrCode);
  end;
end;