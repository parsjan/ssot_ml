#!/bin/bash

# Set the directory where the .deb files are located
DEB_DIR="./genome-offline"

echo "[INFO] Installing GNOME Desktop Environment from $DEB_DIR"

# Step 1: Install all .deb files
sudo dpkg -i $DEB_DIR/*.deb

# Step 2: Fix any broken dependencies (may fail if no internet; try anyway)
sudo apt --fix-broken install -y

# Step 3: Enable graphical target as default
echo "[INFO] Setting graphical.target as default"
sudo systemctl set-default graphical.target

# Step 4: Start GDM (GNOME Display Manager)
echo "[INFO] Starting GDM"
sudo systemctl enable gdm3
sudo systemctl start gdm3

echo "[INFO] GNOME installation and GUI setup complete. Please reboot."
