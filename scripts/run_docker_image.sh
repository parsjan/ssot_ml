#!/bin/bash

IMAGE_TAR_PATH="./docker-tar/ai-env.tar"
CONTAINER_NAME="ai-env-container"

echo "[INFO] Loading Docker image from $IMAGE_TAR_PATH..."
docker load -i "$IMAGE_TAR_PATH"

# Get the most recently loaded image
IMAGE_NAME=$(docker image ls --format "{{.Repository}}:{{.Tag}}" | head -n 1)

if [[ -z "$IMAGE_NAME" ]]; then
    echo "[ERROR] No Docker image found after load. Aborting."
    exit 1
fi

echo "[INFO] Loaded image: $IMAGE_NAME"

# Check for GPU availability
if command -v nvidia-smi &> /dev/null && nvidia-smi -L | grep -q "GPU"; then
    echo "[INFO] GPU detected. Running container with GPU support..."
    docker run -d --gpus all --name "$CONTAINER_NAME" "$IMAGE_NAME"
else
    echo "[WARNING] No GPU detected. Running container without GPU..."
    docker run -d --name "$CONTAINER_NAME" "$IMAGE_NAME"
fi

# ---------------------
# Verification Steps
# ---------------------
echo "[INFO] Verifying container status..."

# Check if container is running
if docker ps --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
    echo "[✔] Container '$CONTAINER_NAME' is running."
else
    echo "[✘] Container '$CONTAINER_NAME' failed to start."
    exit 1
fi

# If GPU was used, test GPU inside container
if docker inspect --format='{{.HostConfig.DeviceRequests}}' "$CONTAINER_NAME" | grep -q 'nvidia'; then
    echo "[INFO] Verifying GPU access inside container..."
    if docker exec "$CONTAINER_NAME" nvidia-smi &> /dev/null; then
        echo "[✔] GPU is accessible inside the container."
    else
        echo "[✘] GPU is NOT accessible inside the container."
    fi
fi

echo "[SUCCESS] Docker image loaded and container started successfully."
