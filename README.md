# Docker files for LLAMA (CUDA, Vulkan) Server

This repository contains Docker files for running the LLAMA server with CUDA and Vulkan support.

## Prerequisites

- Docker and Docker Compose installed on your system
- NVIDIA GPU with CUDA support (for CUDA version)
- AMD GPU with Vulkan support (for Vulkan version)

## Configuration

1. Create a `.env` file in the root directory of the project and set the following variables:

```
BUILD_CONTEXT=./
LLAMA_CUDA_DOCKERFILE=./llama-cuda/Dockerfile
LLAMA_VK_DOCKERFILE=./llama-vk/Dockerfile
SD_CUDA_DOCKERFILE=./sd-cuda/Dockerfile
NGINX_SECRET=your_secret_token
LLAMA_ARGS=--port 8000 --host 0.0.0.0 -n 8192 -ngl 100 -c 32768 --embedding -t 4 -m "/app/llama-3-8b-instruct-1048k.Q6_K.gguf"
LLAMA_MODEL_PATH=/path/to/your/models
SD_ARGS=-m "/app/v1-5-pruned-emaonly.ckpt"
SD_MODEL_PATH=/path/to/your/sd/models
```

Replace `your_secret_token` with your desired secret token for Nginx authentication, and update the `LLAMA_MODEL_PATH` and `SD_MODEL_PATH` variables with the appropriate paths to your models.

2. Generate or provide SSL certificates for Nginx:

```bash
openssl genrsa -out nginx/cert.key 2048
openssl req -new -x509 -days 365 -key nginx/cert.key -out nginx/cert.crt
```

## Building and Running

To build and run the LLAMA server with CUDA support:

```bash
docker-compose -f docker-compose.nvidia.yml up -d --remove-orphans
```

To build and run the LLAMA server with Vulkan support:

```bash
docker-compose -f docker-compose.amd.yml up -d --remove-orphans
```

## Checking Container Status

To check the status of running containers:

```bash
docker-compose -f docker-compose.nvidia.yml ps
```

or

```bash
docker-compose -f docker-compose.amd.yml ps
```

## Making Requests

You can make requests to the LLAMA server using curl:

```bash
curl --request POST \
  --url http://localhost:8000/completion \
  --header "Content-Type: application/json" \
  --data '{"prompt": "Building a website can be done in 10 simple steps:","n_predict": 128}'
```

Make sure to replace `localhost` with the appropriate hostname or IP address if running the server on a different machine.

## Additional Notes

- The `docker-compose.nvidia.yml` file is configured to use CUDA and run on NVIDIA GPUs.
- The `docker-compose.amd.yml` file is configured to use Vulkan and run on AMD GPUs.
- Adjust the `LLAMA_ARGS` and `SD_ARGS` variables in the `.env` file to customize the server and model settings.
- Ensure that you have the necessary models in the specified `LLAMA_MODEL_PATH` and `SD_MODEL_PATH` directories.

For more information on the individual Dockerfiles and their usage, please refer to the respective directories (`llama-cuda`, `llama-vk`, `sd-cuda`).
