FROM ubuntu:14.04

ARG DEBIAN_FRONTEND=noninteractive
ARG userid
ARG groupid
ARG username

# Install required packages for building Tinker Board (S) Android N
# kmod: depmod is required by "make modules_install"
RUN apt-get update && \
    apt-get install -y make gcc python gcc-multilib bc lzop sudo m4 zip git \
    curl openjdk-7-jdk libxml2-utils kmod g++-multilib

RUN curl -o jdk8.tgz https://android.googlesource.com/platform/prebuilts/jdk/jdk8/+archive/master.tar.gz \
    && tar -zxf jdk8.tgz linux-x86 \
    && mv linux-x86 /usr/lib/jvm/java-8-openjdk-amd64 \
    && rm -rf jdk8.tgz

RUN groupadd -g $groupid $username && \
    useradd -m -u $userid -g $groupid $username && \
    echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV HOME=/home/$username
ENV USER=$username
WORKDIR /source

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
