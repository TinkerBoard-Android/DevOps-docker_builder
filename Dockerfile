FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# kmod: depmod is required by "make modules_install"
RUN apt-get update && \
    apt-get install -y make gcc python gcc-multilib bc lzop sudo m4 zip git \
    curl openjdk-8-jdk libxml2-utils kmod g++-multilib python3 libncurses5 \
    rsync

COPY java.security /etc/java-8-openjdk/security/java.security
