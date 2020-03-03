# Add option to use the current user ID and group ID on the host
#USER_ID=$(id -u)
#GROUP_ID=$(id -g)
#OPTION+=" --user $USER_ID:$GROUP_ID"

#CMD="/bin/bash"
#CMD="source build/envsetup.sh && source ./javaenv.sh && lunch rk3399pro-userdebug && make -j12"
#CMD="source build/envsetup.sh && export JAVA_HOME=/source/prebuilts/jdk/jdk8/linux-x86 && export PATH=$JAVA_HOME/bin:$PATH && export CLASSPATH=.:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar && lunch rk3399pro
#-userdebug && make -j12"
#CMD="source ./build/envsetup.sh && lunch BD_Nicola-userdebug && make -j48"
#CMD="cd u-boot && make rk3399pro_defconfig && ./make.sh rk3399pro && cd .. && cd kernel && make ARCH=arm64 rockchip_defconfig -j8 && make ARCH=arm64 rk3399pro-evb-v11.img -j12 && cd .. && source build/en
#vsetup.sh && export JAVA_HOME=/source/prebuilts/jdk/jdk8/linux-x86 && export PATH=$JAVA_HOME/bin:$PATH && export CLASSPATH=.:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar && lunch rk3399pro-userdebug && make -j
#12 && ./mkimage.sh"
#CMD="source ./build/envsetup.sh && lunch BD_Nicola-userdebug && make -j48"
#CMD="rm -rf ./build && rm -rf ./sstate-cache && DATETIME=\`date '+%Y%m%d%H%M%S'\` && echo Builder_\$DATETIME > meta/poky/meta-firmware_version/recipes-bsp/bbversion/files/ver && export TEMPLATECONF=\${PW
#D}/meta/base/conf/mt8516/aud8516-emmc && source meta/poky/oe-init-build-env && echo PARALLEL_MAKE=\\\"-j 16\\\">>conf/local.conf && echo SECURE_BOOT_ENABLE = \\\"yes\\\" >> conf/local.conf && bitbake mtk-
#image-aud-8516 2>&1 | tee build.log"

#CMD="DATETIME=\`date '+%Y%m%d%H%M%S'\` && echo Builder_\$DATETIME > meta/poky/meta-firmware_version/recipes-bsp/bbversion/files/ver && export TEMPLATECONF=\${PWD}/meta/base/conf/mt8516/aud8516-emmc && so
#urce meta/poky/oe-init-build-env && echo PARALLEL_MAKE=\\\"-j 16\\\">>conf/local.conf && echo SECURE_BOOT_ENABLE = \\\"yes\\\" >> conf/local.conf && bitbake mtk-image-aud-8516 2>&1 | tee build.log"

#docker run $OPTION asus/builder$DOCKER_IMAGE:latest /bin/sh -c "$CMD"


#!/bin/bash

set -xe

if [ -x "$(command -v docker)" ]; then
    echo "Docker is installed and the execute permission is granted."
    if getent group docker | grep &>/dev/null "\b$(id -un)\b"; then
	echo "User $(id -un) is in the group docker."
    else
        echo "Docker is not managed as a non-root user."
	echo "Please refer to the following URL to manage Docker as a non-root user."
        echo "https://docs.docker.com/install/linux/linux-postinstall/"
	exit
    fi
else
    echo "Docker is not installed or the execute permission is not granted."
    echo "Please refer to the following URL to install Docker."
    echo "http://redmine.corpnet.asus/projects/configuration-management-service/wiki/Docker"
    exit
fi

if dpkg-query -s qemu-user-static 1>/dev/null 2>&1; then
    echo "The package qemu-user-static is installed."
else
    echo "The package qemu-user-static is not installed yet and it will be installed now."
    sudo apt-get install -y qemu-user-static
fi

if dpkg-query -s binfmt-support 1>/dev/null 2>&1; then
    echo "The package binfmt-support is installed."
else
    echo "The package binfmt-support is not installed yet and it will be installed now."
    sudo apt-get install -y binfmt-support
fi

DIRECTORY_PATH_TO_DOCKER_BUILDER="$(dirname $(readlink -f $0))"
echo "DIRECTORY_PATH_TO_DOCKER_BUILDER: $DIRECTORY_PATH_TO_DOCKER_BUILDER"

DIRECTORY_PATH_TO_SOURCE="$(dirname $DIRECTORY_PATH_TO_DOCKER_BUILDER)"

if [ $# -eq 0 ]; then
    echo "There is no Dockerfile specified. Please specify a Dockerfile to use."
    exit
else
    DOCKERFILE=$1
    if [ ! -f $DIRECTORY_PATH_TO_DOCKER_BUILDER/$DOCKERFILE ]; then
        echo "The Dockerfile [$DIRECTORY_PATH_TO_DOCKER_BUILDER/$DOCKERFILE] is not found."
        exit
    fi
fi

if [ $# -eq 1 ]; then
    echo "There is no directory path to the source provided."
    echo "Use the default directory path to the source [$DIRECTORY_PATH_TO_SOURCE]."
else
    DIRECTORY_PATH_TO_SOURCE=$2
    if [ ! -d $DIRECTORY_PATH_TO_SOURCE ]; then
        echo "The source directory [$DIRECTORY_PATH_TO_SOURCE] is not found."
        exit
    fi
fi

DOCKER_IMAGE=${DOCKERFILE##*.}
DOCKER_IMAGE=${DOCKER_IMAGE,,}
DOCKER_IMAGE="asus/builder-$DOCKER_IMAGE:latest"
#cp ~/.gitconfig gitconfig
docker build --build-arg userid=$(id -u) --build-arg groupid=$(id -g) --build-arg username=$(id -un) -t $DOCKER_IMAGE \
    --file $DIRECTORY_PATH_TO_DOCKER_BUILDER/$DOCKERFILE $DIRECTORY_PATH_TO_DOCKER_BUILDER

OPTIONS="--interactive --privileged --rm --tty"
OPTIONS+=" --volume $DIRECTORY_PATH_TO_SOURCE:/source"
echo "Options to run docker: $OPTIONS"

docker run $OPTIONS $DOCKER_IMAGE
