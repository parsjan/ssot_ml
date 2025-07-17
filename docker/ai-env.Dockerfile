
FROM nvidia/cuda:12.3.2-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Python and pip
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv

# Optional: Copy downloaded .whl files into image

# Install Python packages (ensure versions match host)
RUN pip install --upgrade pip && pip install \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 \
    tensorflow \
    jax[cuda12_pip] -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html \
    transformers opencv-python-headless wandb nltk xgboost theano chromadb openai fastapi uvicorn

CMD [ "python3" ]
