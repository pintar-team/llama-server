FROM rocm/dev-ubuntu-20.04:5.6

LABEL maintainer="Hugging Face"

ARG DEBIAN_FRONTEND=noninteractive
ARG PYTORCH='2.1.0'
ARG TORCH_VISION='0.16.0'
ARG TORCH_AUDIO='2.1.0'
ARG ROCM='5.6'

RUN apt update && \
    apt install -y --no-install-recommends git libsndfile1-dev tesseract-ocr espeak-ng python3 python3-dev python3-pip ffmpeg && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --no-cache-dir --upgrade pip
RUN python3 -m pip install torch==$PYTORCH torchvision==$TORCH_VISION torchaudio==$TORCH_AUDIO --index-url https://download.pytorch.org/whl/rocm$ROCM
RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools ninja git+https://github.com/facebookresearch/detectron2.git pytesseract "itsdangerous<2.1.0"

WORKDIR /app
COPY ./sd-server /app/

RUN python3 -m pip install --no-cache-dir -r /app/requirements.txt
RUN python3 -m pip uninstall py3nvml pynvml -y

CMD ["python3", "server.py"]