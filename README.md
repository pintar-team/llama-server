# Docker files for (CUDA, Vulkan) Server.

CUDA:

### Build local image
```bash
docker build -t local/llama.cpp:server-cuda -f server-cuda.Dockerfile .
```

Run model
```bash
docker run --gpus all -v /path/to/models:/models local/llama.cpp:server-cuda -m /models/7B/ggml-model-q4_0.gguf --port 8000 --host 0.0.0.0 -n 512 --n-gpu-layers 100 --ctx-size 32768 --embedding --parallel 4
```

### Vulkan

Build the image
```bash
docker build -t local/llama.cpp:server-vulkan -f main-vulkan.Dockerfile .
```

run the image
```bash
docker run --gpus all -v /path/to/models:/models local/llama-cpp:server-vulkan -m /models/7B/ggml-model-q4_0.gguf --port 8000 --host 0.0.0.0 --n-gpu-layers 100 --ctx-size 32768 --embedding --parallel 4
```

