FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ARG userid
ARG groupid
ARG username

# Install required packages for building Tinker Board (S) Android N
# kmod: depmod is required by "make modules_install"
RUN apt-get update && \
    apt-get install -y make gcc python gcc-multilib bc lzop sudo m4 zip git \
    curl openjdk-8-jdk libxml2-utils kmod g++-multilib python3 libncurses5 \
    rsync

RUN groupadd -g $groupid $username && \
    useradd -m -u $userid -g $groupid $username && \
    echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV HOME=/home/$username
ENV USER=$username
WORKDIR /source

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
