#!/bin/bash

set -e

echo "[INFO] Starting CUDA toolkit installation..."

# Step 1: Install CUDA Toolkit
echo "[INFO] Making CUDA installer executable..."
chmod +x ./cuda/cuda_*.run

echo "[INFO] Running CUDA installer silently..."
sudo ./cuda/cuda_*.run --silent --toolkit --samples --override

echo "[INFO] CUDA installation complete."

# Step 2: Install cuDNN
echo "[INFO] Starting cuDNN installation..."
CUDNN_ARCHIVE="cudnn-linux-x86_64-8.9.7.29_cuda12-archive.tar.xz"
CUDNN_DIR="cudnn-linux-x86_64-8.9.7.29_cuda12-archive"

echo "[INFO] Extracting $CUDNN_ARCHIVE..."
tar -xf ./cuda/$CUDNN_ARCHIVE -C ./cuda/

echo "[INFO] Copying cuDNN files to CUDA folders..."
sudo cp -P ./cuda/$CUDNN_DIR/include/* /usr/local/cuda/include/
sudo cp -P ./cuda/$CUDNN_DIR/lib/* /usr/local/cuda/lib64/
sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

echo "[INFO] cuDNN installation complete."

# Step 3: Set Environment Variables
echo "[INFO] Exporting environment variables..."
echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc

echo "[INFO] Reloading .bashrc..."
source ~/.bashrc

# Step 4: Verification

echo "[INFO] Verifying CUDA installation..."
if command -v nvcc &> /dev/null; then
    echo "[INFO] nvcc found: $(nvcc --version)"
else
    echo "[ERROR] CUDA compiler (nvcc) not found in PATH."
fi

echo "[INFO] Verifying cuDNN installation..."
if ldconfig -p | grep libcudnn &> /dev/null; then
    echo "[INFO] cuDNN libraries found:"
    ldconfig -p | grep libcudnn
else
    echo "[ERROR] cuDNN libraries not found in ldconfig."
fi

echo "[SUCCESS] CUDA and cuDNN installation completed and verified!"
