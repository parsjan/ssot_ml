#!/bin/bash

set -e

# ---------------------
# Configuration
# ---------------------
DEB_DIR="${1:-./nvidia-docker-deb-packages}"  # Folder containing the 3 .deb files
cd "$DEB_DIR"

echo "📦 Installing NVIDIA Docker dependencies from: $DEB_DIR"

# ---------------------
# Step 1: Install libnvidia-container
# ---------------------
echo "🔹 Installing libnvidia-container1..."
sudo dpkg -i libnvidia-container1_1.14.3-1_amd64.deb || true

# ---------------------
# Step 2: Install nvidia-container-toolkit
# ---------------------
echo "🔹 Installing nvidia-container-toolkit..."
sudo dpkg -i nvidia-container-toolkit_1.14.5-1_amd64.deb || true

# ---------------------
# Step 3: Install nvidia-docker2
# ---------------------
echo "🔹 Installing nvidia-docker2..."
sudo dpkg -i nvidia-docker2_2.13.0-1_all.deb || true

# ---------------------
# Step 4: Fix broken dependencies (if any)
# ---------------------
echo "🛠️ Fixing dependencies..."
sudo apt-get install -f -y

# ---------------------
# Step 5: Configure NVIDIA runtime
# ---------------------
echo "🔧 Configuring NVIDIA runtime for Docker..."
sudo nvidia-ctk runtime configure --runtime=docker

# ---------------------
# Step 6: Restart Docker
# ---------------------
echo "🔁 Restarting Docker..."
sudo systemctl restart docker
sudo systemctl enable docker

# ---------------------
# Step 7: Verify Installation
# ---------------------
echo "✅ Verifying NVIDIA Docker installation..."

# Check if runtime is registered
if docker info | grep -q 'nvidia'; then
    echo "[✔] NVIDIA runtime is registered in Docker."
else
    echo "[✘] NVIDIA runtime is NOT registered. Check configuration."
fi

# Test GPU access inside container
echo "[INFO] Running test container to check GPU access..."
if docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi; then
    echo "[✔] NVIDIA Docker test passed. GPU is accessible inside container."
else
    echo "[✘] NVIDIA Docker test failed. Check driver/runtime installation."
fi

echo "🚀 NVIDIA Docker setup and verification complete."
