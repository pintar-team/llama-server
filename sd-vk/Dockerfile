FROM rocm/pytorch:rocm6.1.2_ubuntu22.04_py3.10_pytorch_release-2.1.2

WORKDIR /app
COPY ./sd-server /app/

RUN python3 -m pip install --no-cache-dir -r /app/requirements.txt
RUN python3 -m pip uninstall py3nvml pynvml -y

ENTRYPOINT ["python3", "server.py"]