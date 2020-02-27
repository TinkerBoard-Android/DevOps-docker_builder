#RUN apt-get update && apt-get install -y git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev  g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc  openjdk-7-jdk
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

# Install required packages for building Tinker Board (S) Debian
# kmod: depmod is required by "make modules_install"
RUN apt-get update && \
    apt-get install -y make gcc gcc-arm-linux-gnueabi device-tree-compiler bc \
    python libssl-dev sudo udev psmisc kmod qemu-user-static parted dosfstools

# Install required packages for building Tinker Edge R Debian
RUN apt-get update && \
    apt-get install -y liblz4-tool time g++ patch wget cpio unzip rsync bzip2 \
    perl gcc-multilib git

RUN groupadd -g $groupid $username && \
    useradd -m -u $userid -g $groupid $username && \
    echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo $username >/root/username

ENV HOME=/home/$username
ENV USER=$username
WORKDIR /source

ENTRYPOINT chroot --skip-chdir --userspec=$(cat /root/username):$(cat /root/username) / /bin/bash -i
