param(
  [Parameter(Mandatory=$true)]
  [string]$UserName
)

Write-Host "==> Seteando usuario por defecto en Ubuntu: $UserName" -ForegroundColor Cyan
ubuntu config --default-user $UserName

Write-Host "Listo. Abre Ubuntu y verifica con: whoami" -ForegroundColor Green
