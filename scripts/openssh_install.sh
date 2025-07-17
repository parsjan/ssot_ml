#!/bin/bash

# Define the filename
DEB_FILE="./openssh-server/openssh-server_1%3a8.9p1-3ubuntu0.13_amd64.deb"

echo "[INFO] Installing OpenSSH Server from $DEB_FILE..."

# Step 1: Install the .deb package
sudo dpkg -i "$DEB_FILE"

# Step 2: Fix missing dependencies (if any)
sudo apt --fix-broken install -y

# Step 3: Enable and start SSH service
echo "[INFO] Enabling and starting SSH service..."
sudo systemctl enable ssh
sudo systemctl start ssh

# Step 4: Check SSH service status
echo "[INFO] Checking SSH service status..."
if systemctl is-active --quiet ssh; then
    echo "[SUCCESS] SSH is running!"
else
    echo "[ERROR] SSH is not running. Check logs using: sudo journalctl -xe"
fi

# validation done
# Optional: Show SSH listening ports
echo "[INFO] SSH is listening on:"
sudo ss -tnlp | grep sshd
