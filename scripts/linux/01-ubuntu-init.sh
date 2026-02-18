#!/usr/bin/env bash
set -e

echo "==> Actualizando paquetes..."
sudo apt update && sudo apt upgrade -y

echo "==> Instalando herramientas base..."
sudo apt install -y git curl unzip jq

echo "==> Creando carpeta de trabajo..."
mkdir -p ~/repos

echo "Listo. Recomendación: trabaja en ~/repos (no en /mnt/c)." 
