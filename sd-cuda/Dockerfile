FROM pytorch/pytorch:2.3.0-cuda12.1-cudnn8-runtime

WORKDIR /app
COPY ./sd-server /app/

RUN python3 -m pip install --no-cache-dir -r /app/requirements.txt

ENTRYPOINT ["python3", "server.py"]
