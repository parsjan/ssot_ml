#!/bin/bash

set -e  # Exit if any command fails

SCRIPT_DIR="./scripts"

declare -a SCRIPTS=(
    "openssh_install.sh"
    "driver_install.sh"
    "cuda_install.sh"
    "install_docker.sh"
    "install_docker_nvidia.sh"
    "enable_mig.sh"
    "create_mig_profiles.sh"
    "anaconda_install.sh"
    "install_python_env.sh"
    "run_docker_image.sh"
    "install_dcgm.sh"
    "install_dcgm_exporter.sh"
    "install_deepstream.sh"
    "install-genome.sh"
)

echo "[INFO] Making all scripts in $SCRIPT_DIR executable..."
for script in "${SCRIPTS[@]}"; do
    chmod +x "$SCRIPT_DIR/$script"
done

echo "[INFO] Starting execution of setup scripts..."
for script in "${SCRIPTS[@]}"; do
    echo "[INFO] Running $script..."
    "$SCRIPT_DIR/$script"
    echo "[INFO] Completed $script"
done

echo "[SUCCESS] All setup scripts ran successfully."
