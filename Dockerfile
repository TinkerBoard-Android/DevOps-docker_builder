FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

# Installing required packages (Ubuntu 18.04)
# https://source.android.com/setup/build/initializing#installing-required-packages-ubuntu-1804
RUN apt-get update && \
    apt-get install -y git-core gnupg flex bison build-essential zip curl \
    zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 libncurses5 \
    lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev \
    libxml2-utils xsltproc unzip fontconfig

# Installing additional packages
# kmod: depmod is required by "make modules_install"
RUN apt-get update && \
    apt-get install -y bc kmod lzop liblz4-tool parted python python3 \
    python-pip rsync sudo udev
