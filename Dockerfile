#RUN apt-get update && apt-get install -y git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip python openjdk-7-jdk
#RUN curl -o jdk8.tgz https://android.googlesource.com/platform/prebuilts/jdk/jdk8/+archive/master.tar.gz \
# && tar -zxf jdk8.tgz linux-x86 \
# && mv linux-x86 /usr/lib/jvm/java-8-openjdk-amd64 \
# && rm -rf jdk8.tgz
#RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo \
# && echo "d06f33115aea44e583c8669375b35aad397176a411de3461897444d247b6c220  /usr/local/bin/repo" | sha256sum --strict -c - \
# && chmod a+x /usr/local/bin/repo
#RUN groupadd -g $groupid $username \
# && echo "export USER="$username >>/home/$username/.gitconfig
#COPY gitconfig /home/$username/.gitconfig
#RUN chown $userid:$groupid /home/$username/.gitconfig

FROM ubuntu:16.04

ARG DEBIAN_FRONTEND=noninteractive
ARG userid
ARG groupid
ARG username

#COPY packages /packages

# Install required packages for building Debian
# Rockchip_RK3288 Linux_SDK_V2.1_发布说明_20180926.pdf
RUN apt-get update && \
    apt-get install -y apt-utils git gcc-arm-linux-gnueabihf u-boot-tools \
    device-tree-compiler mtools parted libudev-dev libusb-1.0-0-dev \
    python-linaro-image-tools linaro-image-tools libssl-dev autotools-dev \
    libsigsegv2 m4 libdrm-dev curl sed make binutils build-essential gcc g++ \
    bash patch gzip bzip2 perl tar cpio python unzip rsync file bc wget \
    libncurses5 libglib2.0-dev openssh-client

# Install additional packages for building base debian system by ubuntu-build-service from linaro
# Rockchip_RK3288 Linux_SDK_V2.1_发布说明_20180926.pdf
RUN apt-get update && \
    apt-get install -y binfmt-support qemu-user-static live-build debootstrap
# The following packages are intalled already as above.
#RUN dpkg -i /packages/* || apt-get install -f -y

# Install additional packages
# kmod: depmod is required by "make modules_install"
RUN apt-get update && \
    apt-get install -y gcc-arm-linux-gnueabi udev psmisc kmod

RUN groupadd -g $groupid $username && \
    useradd -m -u $userid -g $groupid $username && \
    echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo $username >/root/username

ENV HOME=/home/$username
ENV USER=$username
WORKDIR /source

ENTRYPOINT chroot --skip-chdir --userspec=$(cat /root/username):$(cat /root/username) / /bin/bash -i
