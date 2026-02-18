Write-Host "==> Habilitando features: WSL + VirtualMachinePlatform" -ForegroundColor Cyan

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

Write-Host ""
Write-Host "Listo. IMPORTANTE: Reinicia Windows antes de continuar." -ForegroundColor Yellow
Write-Host "Luego ejecuta: scripts/windows/02-install-ubuntu.ps1" -ForegroundColor Yellow
