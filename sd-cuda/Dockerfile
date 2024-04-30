ARG UBUNTU_VERSION=22.04
ARG CUDA_VERSION=11.7.1
ARG BASE_CUDA_DEV_CONTAINER=nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}
ARG BASE_CUDA_RUN_CONTAINER=nvidia/cuda:${CUDA_VERSION}-runtime-ubuntu${UBUNTU_VERSION}

FROM ${BASE_CUDA_DEV_CONTAINER} as build

RUN apt-get update && \
    apt-get install -y git cmake

ARG CUDA_DOCKER_ARCH=all
ARG NPROC=8
ENV NPROC=${NPROC}

ENV CUDA_DOCKER_ARCH=${CUDA_DOCKER_ARCH}

RUN git clone https://github.com/pintar-team/stable-diffusion.cpp.git --recursive
WORKDIR /stable-diffusion.cpp
RUN mkdir build
WORKDIR /stable-diffusion.cpp/build
RUN cmake ..
RUN cmake .. -DSD_CUBLAS=ON && cmake --build . --config Release -j${NPROC}

FROM ubuntu:$UBUNTU_VERSION as runtime

RUN apt-get update && \
    apt-get install -y libcurl4-openssl-dev nvidia-cuda-toolkit

COPY --from=build /stable-diffusion.cpp/build/bin/server /server
ENV LC_ALL=C.utf8
ENTRYPOINT [ "/server" ]
