#!/bin/bash
echo "[INFO] Installing NVIDIA DCGM..."

# Install DCGM package
sudo dpkg -i ./dcgm/datacenter-gpu-manager-4-cuda12_1%3a4.2.3-2_amd64.deb

# Enable and start DCGM service
sudo systemctl enable --now dcgm

# ---------------------
# Verification
# ---------------------

echo "[INFO] Verifying DCGM installation..."

# 1. Check if dcgmi command exists
if ! command -v dcgmi &> /dev/null; then
    echo "[✘] 'dcgmi' command not found. DCGM might not be installed properly."
    exit 1
fi
echo "[✔] dcgmi CLI is available."

# 2. Check if DCGM service is active
if systemctl is-active --quiet dcgm; then
    echo "[✔] DCGM service is active and running."
else
    echo "[✘] DCGM service is not running."
    systemctl status dcgm
    exit 1
fi

# 3. Run a simple dcgmi command to confirm it's functional
if dcgmi discovery -l &> /dev/null; then
    echo "[✔] DCGM is operational. GPU discovery succeeded."
else
    echo "[✘] DCGM command failed. Please check logs."
    dcgmi discovery -l
    exit 1
fi

echo "[SUCCESS] NVIDIA DCGM installed and verified successfully."
