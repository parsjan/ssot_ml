#!/bin/bash

echo "[INFO] Installing DeepStream SDK..."

# Step 1: Install DeepStream SDK
sudo dpkg -i ./deepstream/deepstream-6.4_6.4.0-1_amd64.deb
sudo apt --fix-broken install -y  # Resolves dependencies

# ---------------------
# Step 2: Verification
# ---------------------

echo "[INFO] Verifying DeepStream installation..."

# 1. Check if deepstream-app binary exists
if command -v deepstream-app &> /dev/null; then
    echo "[✔] deepstream-app found: $(which deepstream-app)"
else
    echo "[✘] deepstream-app not found in PATH."
    exit 1
fi

# 2. Try to run deepstream-app with help flag
if deepstream-app --help &> /dev/null; then
    echo "[✔] deepstream-app is executable and responding."
else
    echo "[✘] deepstream-app failed to execute."
    exit 1
fi

# 3. (Optional) Print DeepStream version if available
if [ -f /opt/nvidia/deepstream/deepstream/version.txt ]; then
    echo "[✔] Installed DeepStream version:"
    cat /opt/nvidia/deepstream/deepstream/version.txt
else
    echo "[⚠] Could not determine DeepStream version from version.txt"
fi

echo "[SUCCESS] DeepStream SDK installation verified successfully."
