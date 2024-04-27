ARG UBUNTU_VERSION=22.04
ARG CUDA_VERSION=11.7.1
ARG BASE_CUDA_DEV_CONTAINER=nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}
ARG BASE_CUDA_RUN_CONTAINER=nvidia/cuda:${CUDA_VERSION}-runtime-ubuntu${UBUNTU_VERSION}

FROM ${BASE_CUDA_DEV_CONTAINER} as build

ARG CUDA_DOCKER_ARCH=all
ARG NPROC=8
ENV NPROC=${NPROC}

RUN apt-get update && \
    apt-get install -y build-essential git libcurl4-openssl-dev cmake

ENV CUDA_DOCKER_ARCH=${CUDA_DOCKER_ARCH}
ENV LLAMA_CUDA=1
ENV LLAMA_CURL=1

WORKDIR /app
COPY ./llama.cpp /app

RUN make clean && make -j${NPROC}

FROM ${BASE_CUDA_RUN_CONTAINER} as runtime

RUN apt-get update && \
    apt-get install -y libcurl4-openssl-dev

WORKDIR /

COPY --from=build /app/server /server

ENV LC_ALL=C.utf8

ENTRYPOINT [ "/server", "--port", "8000",  "--host", "0.0.0.0", "-n", "512", "-ngl", "100", "-c", "32768", "--embedding", "-t", "4"  ]
