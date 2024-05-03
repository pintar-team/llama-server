FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu20.04

LABEL maintainer="Hugging Face"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y git libsndfile1-dev tesseract-ocr espeak-ng python3 python3-pip ffmpeg
RUN python3 -m pip install --no-cache-dir --upgrade pip

ARG PYTORCH='2.1.1'
ARG TORCH_VISION=''
ARG TORCH_AUDIO=''
ARG CUDA='cu121'

RUN [ ${#PYTORCH} -gt 0 ] && VERSION='torch=='$PYTORCH'.*' || VERSION='torch'; python3 -m pip install --no-cache-dir -U $VERSION --extra-index-url https://download.pytorch.org/whl/$CUDA
RUN [ ${#TORCH_VISION} -gt 0 ] && VERSION='torchvision=='TORCH_VISION'.*' || VERSION='torchvision'; python3 -m pip install --no-cache-dir -U $VERSION --extra-index-url https://download.pytorch.org/whl/$CUDA
RUN [ ${#TORCH_AUDIO} -gt 0 ] && VERSION='torchaudio=='TORCH_AUDIO'.*' || VERSION='torchaudio'; python3 -m pip install --no-cache-dir -U $VERSION --extra-index-url https://download.pytorch.org/whl/$CUDA

RUN python3 -m pip install --no-cache-dir git+https://github.com/facebookresearch/detectron2.git pytesseract
RUN python3 -m pip install -U "itsdangerous<2.1.0"

WORKDIR /app
COPY ./sd-server /app/

RUN python3 -m pip install --no-cache-dir -r /app/requirements.txt

ENTRYPOINT ["python3", "server.py"]
