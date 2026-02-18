#!/usr/bin/env bash
set -e

echo "==> Instalando Homebrew si no existe..."
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "==> Instalando herramientas base..."
brew update
brew install git jq

mkdir -p ~/repos
echo "Listo. Usa ~/repos como carpeta estándar."
