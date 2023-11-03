# CypatScriptWin

################## WIP DO NOT USE IN CURRENT STATE ################

exit

# start code
Set-Location "$env:USERPROFILE\Downloads"
# open IE for Invoke_WebRequest
Invoke-Item "C:\Program Files\Internet Explorer\iexplore.exe"


Invoke-WebRequest -URI "https://www.7-zip.org/a/7z2301-x64.exe" -FilePath "./7z.exe"


# might work
Start-Process -FilePath "./7z.exe" -ArgumentList '/s', '/v', '/qn'


Invoke-WebRequest -URI "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5.7/npp.8.5.7.Installer.x64.exe" -FilePath "./notepadpp.exe"


Start-Process -FilePath "./notepadpp.exe" -ArgumentList '/s', '/v', '/qn'




Invoke-WebRequest -URI "https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_STIG_GPO_Package_October_2023.zip" -OutFile "./WinServerGovCompliance.zip"

Import-GPO -Path 




# notepad ++
# 7z
# 