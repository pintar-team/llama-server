# Docker files for (CUDA, Vulkan) Server.

CUDA:

### Build local image
```bash
docker build -t local/llama.cpp:server-cuda -f server-cuda.Dockerfile llama.cpp
```

Run model
```bash
docker run --gpus all -v /path/to/models:/models local/llama.cpp:server-cuda -m /models/7B/ggml-model-q4_0.gguf --port 8000 --host 0.0.0.0 -n 512 --n-gpu-layers 100 --ctx-size 32768 --embedding --parallel 4
```

### Vulkan

Build the image
```bash
docker build -t local/llama.cpp-vulkan:server-vulkan -f server-vulkan.Dockerfile llama.cpp
```

run the image
```bash
./bin/server -m ../../westlake-7b-v2.Q5_K_M.gguf --port 8000 --host 0.0.0.0 -n 512 -ngl 100 --ctx-size 32768 --embedding -t 32

docker run -it --rm \
    llama-cpp-vulkan \
    -m "models/westlake-7b-v2.Q5_K_M.gguf" \
    -p "Building a website can be done in 10 simple steps:" \
    -n 400 \
    -e \
    -ngl 33 \
    -t 32
```

