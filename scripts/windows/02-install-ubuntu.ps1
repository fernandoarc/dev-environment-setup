Write-Host "==> Configurando WSL2 e instalando Ubuntu" -ForegroundColor Cyan

wsl --set-default-version 2
wsl --install -d Ubuntu

Write-Host ""
Write-Host "Verificando distros..." -ForegroundColor Cyan
wsl -l -v

Write-Host ""
Write-Host "Si Ubuntu aparece en VERSION=2, OK." -ForegroundColor Green
Write-Host "Ahora abre Ubuntu desde Inicio y ejecuta scripts/linux/01-ubuntu-init.sh" -ForegroundColor Yellow
