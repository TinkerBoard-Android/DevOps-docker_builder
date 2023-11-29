FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

# kmod: depmod is required by "make modules_install"
RUN apt-get update && \
    apt-get install -y bc build-essential cpio device-tree-compiler expect \
    gawk git kmod libssl-dev parted python python3 qemu-user-static rsync sudo \
    time tzdata udev wget zip

# Installing required packages (Ubuntu 18.04)
# https://source.android.com/setup/build/initializing#installing-required-packages-ubuntu-1804
RUN apt-get update && \
    apt-get install -y git-core gnupg flex bison build-essential zip curl \
    zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 libncurses5 \
    lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev \
     libxml2-utils xsltproc unzip fontconfig

RUN apt-get update && \
    apt-get install -y dosfstools

# Rockchip_Developer_Guide_Android11_SDK_V1.1.6_EN.pdf
# RK3288 build failer about LZ4
# The LZ4 version of the system is too low, and the version 1.8.3 or above is required
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/l/lz4/liblz4-1_1.9.2-2_amd64.deb
RUN dpkg -i liblz4-1_1.9.2-2_amd64.deb
RUN rm liblz4-1_1.9.2-2_amd64.deb

RUN wget http://archive.ubuntu.com/ubuntu/pool/main/l/lz4/lz4_1.9.2-2_amd64.deb
RUN dpkg -i lz4_1.9.2-2_amd64.deb
RUN rm lz4_1.9.2-2_amd64.deb

RUN wget http://archive.ubuntu.com/ubuntu/pool/universe/l/lz4/liblz4-tool_1.9.2-2_all.deb
RUN dpkg -i liblz4-tool_1.9.2-2_all.deb
RUN rm liblz4-tool_1.9.2-2_all.deb

RUN apt-get install -y xxd cgpt
