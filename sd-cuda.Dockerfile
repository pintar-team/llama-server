ARG UBUNTU_VERSION=22.04

FROM ubuntu:$UBUNTU_VERSION as build

ARG NPROC=8
ENV NPROC=${NPROC}

RUN apt-get update && apt-get install -y build-essential git cmake

WORKDIR /sd.cpp

COPY . .

RUN mkdir build && cd build && cmake .. -DSD_CUBLAS=ON && cmake --build . --config Release -j${NPROC}

FROM ubuntu:$UBUNTU_VERSION as runtime

COPY --from=build /sd.cpp/build/bin/sd /sd

ENTRYPOINT [ "/sd" ]
