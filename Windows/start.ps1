# CypatScriptWin


# start code
Set-Location "$env:USERPROFILE\Downloads"
# open IE for Invoke_WebRequest
Invoke-Item "C:\Program Files\Internet Explorer\iexplore.exe"

mkdir startscripts

# get scripts
Invoke-WebRequest -URI "https://raw.githubusercontent.com/Aunuxx/Cypat/main/1.ps1" -FilePath "./startscripts/1.ps1"
Invoke-WebRequest -URI "https://raw.githubusercontent.com/Aunuxx/Cypat/main/2.ps1" -FilePath "./startscripts/2.ps1"


# multi proccescing (probably)

Start-Process Powershell.exe -Argumentlist "-file ./startscripts/1.ps1"
Start-Process Powershell.exe -Argumentlist "-file ./startscripts/2.ps1"




# notepad ++
# 7z
# 