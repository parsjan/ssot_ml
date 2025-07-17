FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04


# Install base utilities
RUN apt-get update && apt-get install -y \
    curl git wget unzip build-essential \
    python3 python3-pip python-is-python3


# Install Python dependencies
RUN pip install --upgrade pip




# 1. Install PyTorch from the custom PyTorch index
RUN pip install --prefer-binary --timeout 1000 --retries 5 \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121




# 2. Install everything else from PyPI
RUN pip install \
    tensorflow \
    jax[cuda12_pip] -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html \
    transformers \
    opencv-python-headless \
    wandb \
    nltk \
    xgboost \
    theano \
    chromadb \
    openai \
    fastapi \
    Uvicorn \
    theano-pymc


# DeepStream: Best installed on host or separate container with NVIDIA support


# Create working directory
WORKDIR /workspace


CMD ["/bin/bash"]
