# CypatScriptWin


# start code
Set-Location "$env:USERPROFILE\Downloads"
# open IE for Invoke_WebRequest
Invoke-Item "C:\Program Files\Internet Explorer\iexplore.exe"

# get scripts
Invoke-WebRequest # get file onto gihub


# multi proccescing (probably)

Start-Process Powershell.exe -Argumentlist "-file .\1.ps1"
Start-Process Powershell.exe -Argumentlist "-file .\2.ps1"




# notepad ++
# 7z
