FROM ubuntu:14.04

ARG DEBIAN_FRONTEND=noninteractive
ARG userid
ARG groupid
ARG username

# Install required packages for building Tinker Board 2 Android
# kmod: depmod is required by "make modules_install"
RUN apt-get update && \
    apt-get install -y make gcc python bc liblz4-tool git m4 zip python-crypto \
    xz-utils gcc-multilib g++-multilib kmod bison flex python3-dev fontconfig \
    libssl-dev parted gawk dosfstools wget

RUN wget http://launchpadlibrarian.net/343927385/device-tree-compiler_1.4.5-3_amd64.deb
RUN dpkg -i device-tree-compiler_1.4.5-3_amd64.deb
RUN rm device-tree-compiler_1.4.5-3_amd64.deb

RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update -y
RUN apt-get install -y build-essential python3.6 python3.6-dev
RUN ln -sfn /usr/bin/python3.6 /usr/bin/python3

RUN groupadd -g $groupid $username && \
    useradd -m -u $userid -g $groupid $username && \
    echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo $username >/root/username

ENV HOME=/home/$username
ENV USER=$username
WORKDIR /source

ENTRYPOINT chroot --userspec=$(cat /root/username):$(cat /root/username) / /bin/bash -c "cd /source; /bin/bash -i"
