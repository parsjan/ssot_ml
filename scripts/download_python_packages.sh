#!/bin/bash

WHEEL_DIR=./clean_pip_wheels
mkdir -p "$WHEEL_DIR"

echo "[INFO] Downloading Python 3.12 compatible packages..."

# Use only confirmed compatible versions
pip download --python-version 3.12 --platform manylinux_x86_64 --only-binary=:all: \
    chromadb==0.4.24 jax==0.6.2 nltk==3.8.1 opencv-python-headless==4.9.0.80 \
    tensorflow==2.16.1 torchaudio==2.5.1 torchvision==0.20.1 \
    transformers==4.41.2 wandb==0.17.0 xgboost==2.0.3 \
    -d "$WHEEL_DIR"

echo "[INFO] Downloading Theano (requires source)..."
pip download Theano==1.0.5 -d "$WHEEL_DIR"

echo "[INFO] All packages downloaded to $WHEEL_DIR"

