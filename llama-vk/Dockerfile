ARG UBUNTU_VERSION=jammy

FROM ubuntu:$UBUNTU_VERSION as build

# Install build tools
RUN apt update && apt install -y git libgomp1 build-essential cmake wget

# Install Vulkan SDK
RUN wget -qO - https://packages.lunarg.com/lunarg-signing-key-pub.asc | apt-key add - && \
    wget -qO /etc/apt/sources.list.d/lunarg-vulkan-jammy.list https://packages.lunarg.com/vulkan/lunarg-vulkan-jammy.list && \
    apt update -y && \
    apt-get install -y vulkan-sdk

# Install cURL
RUN apt-get update && \
    apt-get install -y libcurl4-openssl-dev libgomp1

# Build it
WORKDIR /app
COPY ./llama.cpp /app
RUN mkdir build && \
    cd build && \
    cmake .. -DLLAMA_VULKAN=1 -DLLAMA_CURL=1 && \
    cmake --build . --config Release --target llama-server

# Clean up
WORKDIR /
RUN cp /app/build/bin/llama-server /llama-server

ENV LC_ALL=C.utf8

ENTRYPOINT ["/llama-server"]
