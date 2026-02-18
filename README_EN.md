# Dev Environment Setup (Windows / WSL / macOS / Linux)

## Goal
Standardize and reproduce a development environment across different PCs and operating systems, maintaining:

- Consistency (same extensions and practices)
- Reproducibility (scripts and validations)
- Flexibility (configurable user/folder)

---

## Conventions and variables
This README uses placeholders so anyone can replicate the setup:

- `<LINUX_USER>`: Linux user inside WSL / Linux / macOS (example: `fernando`)
- `<REPO_ROOT>`: root folder of this repo (example: `dev-environment-setup/`)
- Standard working folder:
  - Linux/WSL/macOS: `~/repos`
  - Windows (if you work outside WSL): `C:\repos`

> WSL recommendation: work inside `~/repos` and avoid `/mnt/c/...` for better performance.

---

## Repository structure
This repo contains documentation + scripts + the source of truth for extensions.

```text
dev-environment-setup/
├─ README.md
├─ vscode/
│  ├─ extensions.txt
│  └─ settings.json            (optional)
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
### Official downloads
Copy and paste into your browser.

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
### Extensions (source of truth)
The standard list is located at:

- `vscode/extensions.txt`

List installed extensions:

```sh
code --list-extensions
```

Install extensions from the list (Windows PowerShell):

```powershell
Get-Content .\vscode\extensions.txt | ForEach-Object { code --install-extension $_ }
```

Install extensions from the list (macOS/Linux/WSL bash/zsh):
```bash
cat ./vscode/extensions.txt | xargs -n 1 code --install-extension
```

Update the list when you add new extensions:
```sh
code --list-extensions > vscode/extensions.txt
```
### Validations
- `code --version` works
- `code --list-extensions` shows the expected list

### Notes
If `code` is not available in the terminal:
- In VS Code: `Ctrl+Shift+P` → `Shell Command: Install 'code' command in PATH`

## Standard working folders
For consistency across machines:
- Linux/WSL/macOS: ~/repos
- Windows (if you work outside WSL): C:\repo

Recommendation (WSL): work inside ~/repo and avoid /mnt/c/... for better performance.

## Windows 10 (Host)
### 1) Enable required features for WSL2
Equivalent script
- `scripts/windows/01-enable-wsl-features.ps1`

#### Manual (PowerShell as Administrator)
This step enables the components required by WSL2:

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

**Required manual action**
- Restart Windows

#### Validations
After the restart, in PowerShell:

```powershell
wsl --status
```

If there is no error, you’re good.

#### Assumptions / Considerations
Virtualization may need to be enabled in BIOS/UEFI (Intel VT-x / AMD-V)

### 2) Install Ubuntu and set WSL2 as default
#### Equivalent script
`scripts/windows/02-install-ubuntu.ps1`

#### Manual (PowerShell as Administrator)
```powershell
wsl --set-default-version 2
wsl --install -d Ubuntu
```

#### Validations
```powershell
wsl -l -v
```
`Ubuntu` should appear with `VERSION = 2`.

#### Assumptions / Considerations
- The first installation may take some time.
- If it fails due to virtualization, check BIOS settings and “Virtual Machine Platform”.

## WSL (Ubuntu inside Windows)
### 0) Check current user
In Ubuntu:

```bash
whoami
```
If you are `root`, it is recommended to create a regular user for daily work.

### 1) Create a non-root user and grant sudo permissions
#### Manual (Ubuntu)
Replace `<LINUX_USER>` with your user (example: `fernando`):

```bash
sudo adduser <LINUX_USER>
sudo usermod -aG sudo <LINUX_USER>
```

#### Validate that the user exists:
```bash
getent passwd <LINUX_USER>
```
It should return a line with the user.

#### Equivalent script (Windows)
This step is mixed: user creation is done in Ubuntu, but setting the default user is done in Windows.

- `scripts/windows/03-set-default-user.ps1`

In PowerShell:

```powershell
scripts\windows\03-set-default-user.ps1 -UserName <LINUX_USER>
```

#### Final validation
Close Ubuntu and open it again, then:

```bash
whoami
```
It should return `<LINUX_USER>`.

#### Assumptions / Considerations
If ubuntu config --default-user does not exist, the distro may have a different name.
Check in Windows:

```powershell
wsl -l
```
Then use the equivalent command for your distro (example: `ubuntu2204 config --default-user <LINUX_USER>`).

### 2) Base system initialization (Ubuntu)
#### Equivalent script
- `scripts/linux/01-ubuntu-init.sh`

#### Manual (Ubuntu)
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl unzip jq
mkdir -p ~/repos
```

Run via script (Ubuntu)
```bash
chmod +x scripts/linux/01-ubuntu-init.sh
./scripts/linux/01-ubuntu-init.sh
```

#### Validations
```bash
git --version
curl --version
ls ~/repos
```

#### Assumptions / Considerations
Run this from the repo cloned inside WSL (ideally under `~/repos`).

### 3) VS Code in WSL mode (recommended)
#### Goal
Work “like Linux” inside VS Code.

#### Steps
1. Install the VS Code extension: WSL
2. Open a WSL window:
    - `Ctrl+Shift+P` → `WSL: New WSL Window`
3. Bottom-left corner should show:
    - `WSL: Ubuntu`

#### Install extensions in the WSL environment
Important: VS Code installs extensions per environment. Some extensions live in Windows, others in WSL.

```bash
cat ./vscode/extensions.txt | xargs -n 1 code --install-extension
```

#### Validation
```bash
code --list-extensions
```

## macOS
### 1) Base initialization (macOS)
#### Equivalent script
`scripts/macos/01-macos-init.sh`

Run via script:

```bash
chmod +x scripts/macos/01-macos-init.sh
./scripts/macos/01-macos-init.sh
```

### 2) Install VS Code extensions
```bash
cat ./vscode/extensions.txt | xargs -n 1 code --install-extension
```
#### Validations
```bash
git --version
code --version
ls ~/repos
```

## Linux (native)
### 1) Base initialization
#### Equivalent script
- `scripts/linux/01-ubuntu-init.sh`

```bash
chmod +x scripts/linux/01-ubuntu-init.sh
./scripts/linux/01-ubuntu-init.sh
```

### 2) Install VS Code extensions
```bash
cat ./vscode/extensions.txt | xargs -n 1 code --install-extension
```
## Troubleshooting
### Error: WSL_E_WSL_OPTIONAL_COMPONENT_REQUIRED
**Cause:** optional components are not enabled.

**Solution:**
- Run `scripts/windows/01-enable-wsl-features.ps1` as Admin
- Restart Windows

### VS Code in WSL shows root user
**Solution:**
- Create the user in Ubuntu: `adduser <LINUX_USER>`
- Set the default user in Windows: `scripts/windows/03-set-default-user.ps1 -UserName <LINUX_USER>`
- Reopen Ubuntu and validate with `whoami`

## How to keep this repo updated
Whenever you add a standard tool or extension:

1. Update `README.md`:
    - What to install
    - Which platforms it applies to
    - Validation (command + expected output)
    - Equivalent script (if any)
2. If it’s a VS Code extension:
    - Update vscode/extensions.txt:
        ```sh
        code --list-extensions > vscode/extensions.txt
        ```
3. If it needs repeatable commands:
    - Add/update scripts under `scripts/<platform>/...`