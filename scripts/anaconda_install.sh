#!/bin/bash

echo "[INFO] Installing Anaconda silently..."
chmod +x ./anaconda/Anaconda3-2024.02-1-Linux-x86_64.sh
bash ./anaconda/Anaconda3-2024.02-1-Linux-x86_64.sh -b -p $HOME/anaconda3

# Add Anaconda to PATH in .bashrc
echo 'export PATH="$HOME/anaconda3/bin:$PATH"' >> ~/.bashrc

# Immediately export PATH in current session
export PATH="$HOME/anaconda3/bin:$PATH"

echo "[INFO] Anaconda installed successfully."

# Step: Verify Anaconda Installation
echo "[INFO] Verifying Anaconda installation..."
if command -v conda &> /dev/null; then
    echo "[SUCCESS] Anaconda is installed and available in PATH."
    conda --version
else
    echo "[ERROR] Anaconda installation verification failed. 'conda' not found."
fi
