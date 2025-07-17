#!/bin/bash

set -e

DEB_DIR="./docker-debs"

echo "Installing Docker from .deb files in $DEB_DIR"

# Change to directory where .deb files are kept
cd "$DEB_DIR"

# Step 1: Install containerd.io first
echo "Installing containerd.io..."
sudo dpkg -i ./containerd.io_*.deb

# Step 2: Install docker-ce-cli
echo "Installing docker-ce-cli..."
sudo dpkg -i ./docker-ce-cli_*.deb

# Step 3: Install docker-ce
echo "Installing docker-ce..."
sudo dpkg -i ./docker-ce_*.deb

# Step 4: Optionally install docker-compose-plugin
if ls docker-compose-plugin_*.deb 1> /dev/null 2>&1; then
    echo "Installing docker-compose-plugin..."
    sudo dpkg -i ./docker-compose-plugin_*.deb
else
    echo "docker-compose-plugin not found. Skipping."
fi

# Step 5: Start Docker
echo "Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Docker installed successfully!"
docker --version
