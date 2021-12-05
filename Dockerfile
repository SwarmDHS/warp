FROM debian:buster

# Install build dependencies in the container
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
    xz-utils \
    units

RUN mkdir /build
COPY . /build

ENV PATH="/build:${PATH}"
ENV PIMOD_CACHE=".cache"

WORKDIR /build

# Start injecting our code, dependencies, and libraries
# Pimod mounts both the boot and ext4 partitions, uses chroot
# to inject our code and dependencies, then exits and unmounts the
# target image
CMD pimod/pimod.sh ./Pifile