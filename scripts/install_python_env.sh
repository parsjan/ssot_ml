#!/bin/bash

set -e

ENV_DIR="py312_env"
WHEEL_ROOT="./pip_wheels"

echo "[INFO] Starting offline installation..."

# Step 1: Create Python 3.12 virtual environment
echo "[INFO] Creating Python 3.12 virtual environment at $ENV_DIR..."
python3.12 -m venv "$ENV_DIR"

# Activate environment
source "$ENV_DIR/bin/activate"

# Step 2: Upgrade pip
echo "[INFO] Upgrading pip..."
pip install --upgrade pip

# Step 3: Install packages from folders
echo "[INFO] Installing packages from $WHEEL_ROOT..."

for dir in "$WHEEL_ROOT"/*/; do
    echo "[INFO] Entering directory: $dir"

    for pkg in "$dir"*.whl "$dir"*.tar.gz; do
        if [ -f "$pkg" ]; then
            PKG_NAME=$(basename "$pkg")

            # Try to parse package name and version from filename
            NAME_VER=$(echo "$PKG_NAME" | sed -E 's/^([a-zA-Z0-9_\-]+)-([0-9\.]+).*/\1==\2/')
            if pip show $(echo "$NAME_VER" | cut -d'=' -f1) > /dev/null 2>&1; then
                echo "[SKIPPED] $NAME_VER is already installed."
            else
                echo "[INSTALLING] $PKG_NAME..."
                if pip install "$pkg"; then
                    echo "[INSTALLED] $NAME_VER"
                else
                    echo "[ERROR] Failed to install $PKG_NAME"
                fi
            fi
        fi
    done
done

# Step 4: Verification
echo -e "\n[INFO] Verifying installations..."

for dir in "$WHEEL_ROOT"/*/; do
    for pkg in "$dir"*.whl "$dir"*.tar.gz; do
        if [ -f "$pkg" ]; then
            MODULE=$(basename "$pkg" | cut -d'-' -f1 | tr '-' '_' | tr '[:upper:]' '[:lower:]')
            echo -n "Verifying import for $MODULE... "
