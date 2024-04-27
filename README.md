# Docker files for (CUDA, Vulkan) Server.

## Docker compose

for build nginx need generate or provide certificate, in nginx dir
```bash
openssl genrsa -out nginx/cert.key  2048
openssl req -new -x509 -days 365 -key nginx/cert.key -out cert.crt
```

building
```bash
# Full build
docker-compose build
# or wihtout cache
docker-compose build --no-cache
# or build only one service
docker-compose build nginx --no-cache
```

Run
```bash
docker-compose up
```

Check images
```bash
docker-compose ps
```


CUDA:

### Build local image
```bash
docker build --build-arg -t llama-cpp-cuda -f llama-cuda llama.cpp
```

Run model
```bash
docker run -p 8000:8000 \
    --gpus all \
    NPROC=$(nproc) \
    -v "$(pwd):/app:z" \
    llama-cpp-cuda \
    -m "/app/westlake-7b-v2.Q5_K_M.gguf"
```

### Vulkan

Build the image
```bash
docker build -t llama-cpp-vulkan -f llama-vk llama.cpp
```

run the image
```bash
docker run -p 8000:8000 \
    -d \
    -it \
    --rm \
    -v "$(pwd)/llama.cpp:/app:z" \
    --device /dev/dri/renderD128:/dev/dri/renderD128 \
    --device /dev/dri/card1:/dev/dri/card1 \
    llama-cpp-vulkan \
    -m "/app/models/westlake-7b-v2.q5_k_m.gguf"
```

try request
```bash
curl --request POST \
    --url http://localhost:8000/completion \
    --header "Content-Type: application/json" \
    --data '{"prompt": "Building a website can be done in 10 simple steps:","n_predict": 128}'
```


### stable-diffusion

```bash
docker build --build-arg NPROC=$(nproc)  -t sd-cpu -f sd-cuda.Dockerfile stable-diffusion.cpp
```

run the image
```bash
docker run -p 8000:8000 \
            --gpus all \
            -u $(id -u):$(id -g) \
            -v "$(pwd):/app" \
            sd-cuda \
            -m "/app/v1-5-pruned-emaonly.ckpt" \
            -p "city cyberpunk" \
            -o "/app/out.png" \
            -v \
            --type f32
```

