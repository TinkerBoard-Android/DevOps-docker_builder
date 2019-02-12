FROM ubuntu:14.04

LABEL maintainer="leslie_yu@asus.com"

ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /home/builder
ENV HOME=/home/builder

# Install required packages (Ubuntu 14.04) for AOSP builds
# https://source.android.com/setup/build/initializing.html
RUN apt-get update && \
    apt-get install -y git-core gnupg flex bison gperf build-essential zip curl \
    zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev \
    x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils \
    xsltproc unzip

# Install OpenJDK JDK7 for Android Marshmallow builds
RUN apt-get install -y openjdk-7-jdk

# Install additional packages for Intel CherryTrail Android Marshmallow builds
RUN apt-get install -y bc python

# Install required packages for the build host for the Yocto project
# https://www.yoctoproject.org/docs/latest/mega-manual/mega-manual.html#required-packages-for-the-build-host
# Essentials: Packages needed to build an image on a headless system:
RUN apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
    build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
    xz-utils debianutils iputils-ping

# Get gn as mentioned in MTK MT8516_Yocto_Linux_User_Guide_V2.7.3
ADD http://storage.googleapis.com/chromium-gn/3fd43e5e0dcc674f0a0c004ec290d04bb2e1c60e /usr/bin/gn
RUN chmod 777 /usr/bin/gn

# Usee bash as mentioned in MTK MT8516_Yocto_Linux_User_Guide_V2.7.3
# /bin/sh points to Dash by default, reconfigure to use bash
# https://superuser.com/questions/715722/how-to-do-dpkg-reconfigure-dash-as-bash-automatically
RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure -p critical dash

# Configure the locale to fix the following problem when runing bitbake
# https://wiki.yoctoproject.org/wiki/TipsAndTricks/ResolvingLocaleIssues
# Please use a locale setting which supports utf-8.
# Python can't change the filesystem locale after loading so we need a utf-8 when python starts or things won't work.
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# Install the latest git to fix the following issue
# fatal: unable to look up current user in the passwd file: no such user
# https://www.itzgeek.com/how-tos/mini-howtos/add-apt-repository-command-not-found-debian-ubuntu-quick-fix.html
# https://askubuntu.com/questions/579589/upgrade-git-version-on-ubuntu-14-04
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:git-core/ppa
RUN apt-get update && \
    apt-get install -y git

# Install additional packages for the build host for the ASUS MTK MT8516 Yocto projecti AI800M PRO
RUN apt-get install -y rpm2cpio ninja-build sshpass

# Install additional packages for Rockchip RK3399PRO Android Oreo builds
RUN apt-get install -y liblz4-tool

# Work in the source directory
WORKDIR /source

# Make /etc/passwd writeable for all since we need dynamically to add an entry for ssh
RUN chmod -R a+w $HOME /etc/passwd

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
#CMD "/bin/bash"
