FROM ubuntu:14.04

ARG DEBIAN_FRONTEND=noninteractive
ARG userid
ARG groupid
ARG username

# Install required packages for building Tinker Edge R Android
# kmod: depmod is required by "make modules_install"
RUN apt-get update && \
    apt-get install -y make gcc python bc liblz4-tool git m4 zip python-crypto \
    xz-utils gcc-multilib g++-multilib kmod

RUN groupadd -g $groupid $username && \
    useradd -m -u $userid -g $groupid $username && \
    echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV HOME=/home/$username
ENV USER=$username
WORKDIR /source

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
