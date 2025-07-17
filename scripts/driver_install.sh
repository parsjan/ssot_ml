#!/bin/bash

echo "[INFO] Stopping graphical target..."
sudo systemctl isolate multi-user.target
sudo systemctl stop gdm3

echo "[INFO] Making driver installer executable..."
chmod +x ./drivers/NVIDIA-Linux-*.run

echo "[INFO] Installing NVIDIA driver silently..."
sudo ./drivers/NVIDIA-Linux-*.run --silent --dkms --disable-nouveau

echo "[INFO] Driver install complete."

echo "[INFO] Verifying NVIDIA driver installation..."

# Check if `nvidia-smi` exists and show GPU info
if command -v nvidia-smi &> /dev/null; then
    echo "[INFO] nvidia-smi found. Displaying GPU status:"
    nvidia-smi
else
    echo "[ERROR] nvidia-smi not found. NVIDIA driver may not be installed correctly."
fi

# Check NVIDIA kernel module
echo "[INFO] Checking if NVIDIA kernel module is loaded..."
lsmod | grep nvidia && echo "[INFO] NVIDIA kernel module loaded." || echo "[ERROR] NVIDIA kernel module not loaded."
