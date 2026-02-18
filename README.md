# Dev Environment Setup (Windows / WSL / macOS / Linux)

## Objetivo
Estandarizar y reproducir un entorno de desarrollo en distintos PCs y sistemas operativos, manteniendo:

- Consistencia (mismas extensiones y prácticas)
- Reproducibilidad (scripts y validaciones)
- Flexibilidad (usuario/carpeta configurable)

---

## Convenciones y variables
En este README se usan placeholders para que cualquiera lo replique:

- `<LINUX_USER>`: usuario Linux dentro de WSL / Linux / macOS (ejemplo: `fernando`)
- `<REPO_ROOT>`: carpeta raíz de este repo (ejemplo: `dev-environment-setup/`)
- Carpeta estándar de trabajo:
  - Linux/WSL/macOS: `~/repos`
  - Windows (si trabajas fuera de WSL): `C:\repos`

> Recomendación en WSL: trabajar dentro de `~/repos` y evitar `/mnt/c/...` por rendimiento.

---

## Estructura del repo
Este repo contiene documentación + scripts + fuente de verdad de extensiones.

```text
dev-environment-setup/
├─ README.md
├─ vscode/
│  ├─ extensions.txt
│  └─ settings.json            (opcional)
└─ scripts/
   ├─ windows/
   │  ├─ 01-enable-wsl-features.ps1
   │  ├─ 02-install-ubuntu.ps1
   │  └─ 03-set-default-user.ps1
   ├─ linux/
   │  └─ 01-ubuntu-init.sh
   └─ macos/
      └─ 01-macos-init.sh

```
## Descargas oficiales
Copia y pega en el navegador.

```text
VS Code: https://code.visualstudio.com/
WSL (docs): https://learn.microsoft.com/windows/wsl/
Docker Desktop: https://www.docker.com/products/docker-desktop/
Git: https://git-scm.com/downloads
Node.js (LTS): https://nodejs.org/
Power BI Desktop: https://powerbi.microsoft.com/desktop/
PostgreSQL: https://www.postgresql.org/download/
SQL Server (Developer): https://www.microsoft.com/sql-server/sql-server-downloads
DBeaver: https://dbeaver.io/download/
```

## VS Code
### Extensiones (fuente de verdad)
La lista estándar está en:
- `vscode/extensions.txt`

Ver extensiones instaladas:

```sh
code --list-extensions
```

Instalar extensiones desde la lista (Windows PowerShell):

```powershell
Get-Content .\vscode\extensions.txt | ForEach-Object { code --install-extension $_ }
```

Instalar extensiones desde la lista (macOS/Linux/WSL bash/zsh):

```bash
cat ./vscode/extensions.txt | xargs -n 1 code --install-extension
```

Actualizar la lista cuando agregues extensiones nuevas:

```sh
code --list-extensions > vscode/extensions.txt
```

### Validaciones
- `code --version` funciona
- `code --list-extensions` muestra la lista esperada

### Consideraciones
- Si `code` no existe en la terminal:
    - En VS Code: `Ctrl+Shift+P` → `Shell Command: Install 'code' command in PATH`

## Estándar de carpetas de trabajo
Para consistencia entre equipos:
- Linux/WSL/macOS: ~/repos
- Windows (si trabajas fuera de WSL): `C:\repo`

Recomendación (WSL): trabajar dentro de `~/repo` y evitar `/mnt/c/...` por rendimiento.

## Windows 10 (Host)
### 1) Habilitar features para WSL2
Script equivalente
- `scripts/windows/01-enable-wsl-features.ps1`

#### Manual (PowerShell como Administrador)
Este paso habilita componentes requeridos por WSL2:

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

#### Acción manual requerida
- Reiniciar Windows

#### Validaciones
Después del reinicio, en PowerShell:

```powershell
wsl --status
```

Si no hay error, vas bien.

#### Supuestos / Consideraciones
- Puede requerir virtualización habilitada en BIOS/UEFI (Intel VT-x / AMD-V)

### 2) Instalar Ubuntu y setear WSL2 como default
Script equivalente
scripts/windows/02-install-ubuntu.ps1

#### Manual (PowerShell como Administrador)
```powershell
wsl --set-default-version 2
wsl --install -d Ubuntu
```

#### Validaciones
```powershell
wsl -l -v
```
Debe aparecer `Ubuntu` con `VERSION = 2`.

#### Supuestos / Consideraciones
- La primera instalación puede tardar.
- Si falla por virtualización, revisar BIOS y “Virtual Machine Platform”.

## WSL (Ubuntu dentro de Windows)
### 0) Comprobar usuario actual
En Ubuntu:

```bash
whoami
```

Si estás en root, se recomienda crear un usuario normal para trabajo diario.

### 1) Crear usuario no-root y darle permisos sudo
#### Manual (Ubuntu)
Reemplaza `<LINUX_USER>` por tu usuario (ejemplo: `fernando`):

```bash
sudo adduser <LINUX_USER>
sudo usermod -aG sudo <LINUX_USER>
```

Validar que el usuario existe
```bash
getent passwd <LINUX_USER>
```
Debe devolver una línea con el usuario.

#### Script equivalente (Windows)
Este paso es mixto: crear usuario es en Ubuntu, pero setearlo como default es en Windows.
- `scripts/windows/03-set-default-user.ps1`

En PowerShell:

```shpowershell
scripts\windows\03-set-default-user.ps1 -UserName <LINUX_USER>
```

#### Validación final
Cierra Ubuntu y vuelve a abrirlo, luego:

```bash
whoami
```
Debe decir `<LINUX_USER>`.

#### Supuestos / Consideraciones
Si `ubuntu config --default-user` no existe, la distro podría llamarse distinto.
Verifica en Windows:

```powershell
wsl -l
```

y usa el comando equivalente de tu distro (ejemplo: `ubuntu2204 config --default-user <LINUX_USER>`).

### 2) Inicialización base del sistema (Ubuntu)
#### Script equivalente
- `scripts/linux/01-ubuntu-init.sh`

#### Manual (Ubuntu)
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl unzip jq
mkdir -p ~/repos
```

#### Ejecutar vía script (Ubuntu)
```bash
Copiar código
chmod +x scripts/linux/01-ubuntu-init.sh
./scripts/linux/01-ubuntu-init.sh
```

#### Validaciones
```bash
git --version
curl --version
ls ~/repos
```
#### Supuestos / Consideraciones
- Ejecutar esto desde el repo clonado dentro de WSL (idealmente en ~/repos).

### 3) VS Code en modo WSL (recomendado)
#### Objetivo
Trabajar “como Linux” dentro de VS Code.

#### Pasos
1. Instalar extensión VS Code: `WSL`
2. Abrir una ventana WSL:
    - `Ctrl+Shift+P` → `WSL: New WSL Window`
3. En la esquina inferior izquierda debe decir:
    - `WSL: Ubuntu`

#### Instalar extensiones en entorno WSL
Importante: VS Code instala extensiones por entorno. Algunas van en Windows, otras en WSL.

```bash
cat ./vscode/extensions.txt | xargs -n 1 code --install-extension
```

#### Validación
```bash
code --list-extensions
```

## macOS
### 1) Inicialización base (macOS)
#### Script equivalente
- `scripts/macos/01-macos-init.sh`

Ejecutar vía script
```bash
chmod +x scripts/macos/01-macos-init.sh
./scripts/macos/01-macos-init.sh
```

### 2) Instalar extensiones VS Code
```bash
cat ./vscode/extensions.txt | xargs -n 1 code --install-extension
```

#### Validaciones
```bash
git --version
code --version
ls ~/repos
```

## Linux (nativo)
### 1) Inicialización base
#### Script equivalente
- `scripts/linux/01-ubuntu-init.sh`

```bash
chmod +x scripts/linux/01-ubuntu-init.sh
./scripts/linux/01-ubuntu-init.sh
```

### 2) Instalar extensiones VS Code
```bash
cat ./vscode/extensions.txt | xargs -n 1 code --install-extension
```

## Troubleshooting
### Error: WSL_E_WSL_OPTIONAL_COMPONENT_REQUIRED

**Causa:** no están habilitados los componentes opcionales.

**Solución**:
- Ejecutar scripts/windows/01-enable-wsl-features.ps1 como Admin
- Reiniciar Windows

### VS Code en WSL aparece como root
**Solución**:
- Crear usuario en Ubuntu: `adduser <LINUX_USER>`
- Setear default user en Windows: `scripts/windows/03-set-default-user.ps1 -UserName <LINUX_USER>`
- Reabrir Ubuntu y validar con `whoami`

## Cómo mantener este repo actualizado
Cada vez que agregues una herramienta o extensión estándar:

1. Actualiza README.md:
    - Qué se instala
    - En qué plataformas aplica
    - Validación (comando + resultado esperado)
    - Script equivalente (si existe)
2. Si es extensión VS Code:
    - Actualiza `vscode/extensions.txt`:
        ```sh
        code --list-extensions > vscode/extensions.txt
        ```
3. Si requiere comandos repetibles:
    - Agrega/ajusta scripts en `scripts/<plataforma>/...`

