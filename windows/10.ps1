# use for Windows 10 and Server
# use server.ps1 for server specific commands, server.ps1 does not work on 10.
# CypatScriptWin

# frin


# start code
Set-Location "$env:USERPROFILE\Downloads"


#Invoke-WebRequest -URI "https://www.7-zip.org/a/7z2301-x64.exe" -OutFile "./7z.exe"


#Start-Process -FilePath "./7z.exe"


#Invoke-WebRequest -URI "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5.7/npp.8.5.7.Installer.x64.exe" -OutFile "./notepadpp.exe"


#Start-Process -FilePath "./notepadpp.exe" -ArgumentList '/S', '/v', '/qn'


Invoke-WebRequest -URI "https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_STIG_GPO_Package_October_2023.zip" -OutFile "./Win10GovCompliance.zip"

mkdir Win10GovCompliance

Expand-Archive -Path "./Win10GovCompliance.zip" -DestinationPath "./Win10GovCompliance"

Start-Process -FilePath "./Win10GovCompliance/DoD Windows 10 V2R8/Reports/DoD Windows 10 STIG Computer v2r8.html"
Start-Process -FilePath "./Win10GovCompliance/DoD Windows 10 V2R8/Reports/DoD Windows 10 STIG User v2r8.html"
Start-Process -FilePath "./Win10GovCompliance/DoD Microsoft Defender Antivirus STIG V2R4/Reports/DoD Microsoft Defender Antivirus STIG Computer v2r4.html"
Start-Process -FilePath "./Win10GovCompliance/DoD Windows Defender Firewall V2R2/Reports/DoD Windows Defender Firewall STIG v2r2.html"

