# 7z
# Notepad ++

Set-Location "$env:USERPROFILE\Downloads"


Invoke-WebRequest -URI "https://www.7-zip.org/a/7z2301-x64.exe" -FilePath "./7z.exe"


 # might work
Start-Process -FilePath "./7z.exe" -ArgumentList '/s', '/v', '/qn'



Invoke-WebRequest -URI "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5.7/npp.8.5.7.Installer.x64.exe" -FilePath "./notepadpp.exe"


Start-Process -FilePath "./notepadpp.exe" -ArgumentList '/s', '/v', '/qn'


