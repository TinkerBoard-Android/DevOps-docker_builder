FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive
ARG userid
ARG groupid
ARG username

# Install required packages for building Tinker Board 2 Android
RUN apt-get update
RUN apt-get install -y git git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip python bc liblz4-tool m4 python-crypto xz-utils kmod bison flex python3-dev fontconfig libssl-dev parted gawk cpio rsync

RUN apt-get update
RUN apt-get install -y dosfstools wget sudo

RUN wget http://launchpadlibrarian.net/343927385/device-tree-compiler_1.4.5-3_amd64.deb
RUN dpkg -i device-tree-compiler_1.4.5-3_amd64.deb
RUN rm device-tree-compiler_1.4.5-3_amd64.deb

RUN apt-get update
RUN apt-get install -y udev

RUN apt-get install -y openjdk-8-jdk

RUN groupadd -g $groupid $username && \
    useradd -m -u $userid -g $groupid $username && \
    echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo $username >/root/username

RUN wget http://archive.ubuntu.com/ubuntu/pool/main/l/lz4/liblz4-1_1.9.2-2_amd64.deb
RUN dpkg -i liblz4-1_1.9.2-2_amd64.deb
RUN rm liblz4-1_1.9.2-2_amd64.deb

RUN wget http://archive.ubuntu.com/ubuntu/pool/main/l/lz4/lz4_1.9.2-2_amd64.deb
RUN dpkg -i lz4_1.9.2-2_amd64.deb
RUN rm lz4_1.9.2-2_amd64.deb

RUN wget http://archive.ubuntu.com/ubuntu/pool/universe/l/lz4/liblz4-tool_1.9.2-2_all.deb
RUN dpkg -i liblz4-tool_1.9.2-2_all.deb
RUN rm liblz4-tool_1.9.2-2_all.deb

ENV HOME=/home/$username
ENV USER=$username
WORKDIR /source

ENTRYPOINT chroot --userspec=$(cat /root/username):$(cat /root/username) / /bin/bash -c "cd /source; /bin/bash -i"
