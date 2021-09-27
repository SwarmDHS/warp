FROM debian:buster

ARG SSID
ARG PASS

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
  wget \
  xz-utils

RUN mkdir /build
COPY . /build

ENV PATH="/build:${PATH}"
ENV PIMOD_CACHE=".cache"

ENV BOOTSTRAP_WPA_SSID=$SSID
ENV BOOTSTRAP_WPA_PASSPHRASE=$PASS

WORKDIR /build

CMD pimod/pimod.sh ./Pifile
