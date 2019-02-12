#!/bin/bash
#
# Author: Leslie Yu <leslie_yu@asus.com>
#

set -e

if [ $# -eq 0 ]; then
    echo "Please provide the path to the source as the argument."
    exit
fi

PATH_TO_SOURCE=$1
if [ ! -d $PATH_TO_SOURCE ]; then
  echo "The source directory [$PATH_TO_SOURCE] is not found."
  exit
fi

OPTION="--rm -it"

# Add option to use the current user ID and group ID on the host
USER_ID=$(id -u)
GROUP_ID=$(id -g)
OPTION+=" --user $USER_ID:$GROUP_ID"
#OPTION+=" --volume /home/leslie_yu/ASUS/source/gerrrit/mediatek/MTK8516_YOCTO_WW05_ASUS_R1:/source"
#OPTION+=" --volume /home/leslie_yu/ASUS/source/gerrrit/intel/m-mr1-r2_cht_hr-dev:/source"
#OPTION+=" --volume /mnt/storage3/ASUS/source/gerrit/rockchip/rk3399pro_oreo_sdk_v1.2.0:/source"
OPTION+=" --volume $PATH_TO_SOURCE:/source"

CMD="/bin/bash"
#CMD="source build/envsetup.sh && source ./javaenv.sh && lunch rk3399pro-userdebug && make -j12"
#CMD="source build/envsetup.sh && export JAVA_HOME=/source/prebuilts/jdk/jdk8/linux-x86 && export PATH=$JAVA_HOME/bin:$PATH && export CLASSPATH=.:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar && lunch rk3399pro-userdebug && make -j12"
#CMD="source ./build/envsetup.sh && lunch BD_Nicola-userdebug && make -j48"
#CMD="cd u-boot && make rk3399pro_defconfig && ./make.sh rk3399pro && cd .. && cd kernel && make ARCH=arm64 rockchip_defconfig -j8 && make ARCH=arm64 rk3399pro-evb-v11.img -j12 && cd .. && source build/envsetup.sh && export JAVA_HOME=/source/prebuilts/jdk/jdk8/linux-x86 && export PATH=$JAVA_HOME/bin:$PATH && export CLASSPATH=.:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar && lunch rk3399pro-userdebug && make -j12 && ./mkimage.sh"
#CMD="source ./build/envsetup.sh && lunch BD_Nicola-userdebug && make -j48"
#CMD="rm -rf ./build && rm -rf ./sstate-cache && DATETIME=\`date '+%Y%m%d%H%M%S'\` && echo Builder_\$DATETIME > meta/poky/meta-firmware_version/recipes-bsp/bbversion/files/ver && export TEMPLATECONF=\${PWD}/meta/base/conf/mt8516/aud8516-emmc && source meta/poky/oe-init-build-env && echo PARALLEL_MAKE=\\\"-j 16\\\">>conf/local.conf && echo SECURE_BOOT_ENABLE = \\\"yes\\\" >> conf/local.conf && bitbake mtk-image-aud-8516 2>&1 | tee build.log"

#CMD="DATETIME=\`date '+%Y%m%d%H%M%S'\` && echo Builder_\$DATETIME > meta/poky/meta-firmware_version/recipes-bsp/bbversion/files/ver && export TEMPLATECONF=\${PWD}/meta/base/conf/mt8516/aud8516-emmc && source meta/poky/oe-init-build-env && echo PARALLEL_MAKE=\\\"-j 16\\\">>conf/local.conf && echo SECURE_BOOT_ENABLE = \\\"yes\\\" >> conf/local.conf && bitbake mtk-image-aud-8516 2>&1 | tee build.log"

echo "Option to run docker: $OPTION"
#echo "Shell command to be exectued in the container: $CMD"

docker run $OPTION asus/builder:latest /bin/sh -c "$CMD"
#docker run $OPTION asus/builder:latest
