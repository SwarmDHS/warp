FROM debian:buster

RUN apt-get update && \
  apt-get install -y \
  binfmt-support \
  fdisk \
  file \
  kpartx \
  lsof \
  parted \
  qemu \
  qemu-user-static \
  unzip \
  p7zip-full \
  tree \
  wget \
  xz-utils

RUN mkdir /build
COPY . /build

ENV PATH="/build:${PATH}"
ENV PIMOD_CACHE=".cache"

WORKDIR /build

CMD pimod/pimod.sh ./Pifile
