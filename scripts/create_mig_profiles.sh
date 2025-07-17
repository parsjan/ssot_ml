#!/bin/bash

CONFIG_FILE="./mig_config.txt"
GPU_INDEX=0

echo "[INFO] Checking if MIG mode is enabled..."
MIG_MODE=$(nvidia-smi -i $GPU_INDEX -q | grep "MIG Mode" | head -1 | awk '{print $NF}')
if [ "$MIG_MODE" != "Enabled" ]; then
    echo "[ERROR] MIG mode is not enabled on GPU $GPU_INDEX. Enable it first:"
    echo "  sudo nvidia-smi -i $GPU_INDEX -mig 1"
    exit 1
fi

echo "[INFO] Clearing existing MIG instances..."
sudo nvidia-smi mig -i $GPU_INDEX -dci
sudo nvidia-smi mig -i $GPU_INDEX -dgi

echo "[INFO] Creating MIG profiles from $CONFIG_FILE..."

while IFS= read -r profile; do
    if [[ -n "$profile" ]]; then
        echo "[INFO] Creating MIG instance with profile: $profile"
        sudo nvidia-smi mig -i $GPU_INDEX -cgi "$profile"
    fi
done < "$CONFIG_FILE"

echo "[INFO] Listing created MIG instances:"
nvidia-smi -L
