#!/bin/bash


# Add option to use the current user ID and group ID on the host
USER_ID=$(id -u)
GROUP_ID=$(id -g)
OPTION+=" --user $USER_ID:$GROUP_ID"

CMD="/bin/bash"
#CMD="source build/envsetup.sh && source ./javaenv.sh && lunch rk3399pro-userdebug && make -j12"
#CMD="source build/envsetup.sh && export JAVA_HOME=/source/prebuilts/jdk/jdk8/linux-x86 && export PATH=$JAVA_HOME/bin:$PATH && export CLASSPATH=.:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar && lunch rk3399pro-userdebug && make -j12"
#CMD="source ./build/envsetup.sh && lunch BD_Nicola-userdebug && make -j48"
#CMD="cd u-boot && make rk3399pro_defconfig && ./make.sh rk3399pro && cd .. && cd kernel && make ARCH=arm64 rockchip_defconfig -j8 && make ARCH=arm64 rk3399pro-evb-v11.img -j12 && cd .. && source build/envsetup.sh && export JAVA_HOME=/source/prebuilts/jdk/jdk8/linux-x86 && export PATH=$JAVA_HOME/bin:$PATH && export CLASSPATH=.:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar && lunch rk3399pro-userdebug && make -j12 && ./mkimage.sh"
#CMD="source ./build/envsetup.sh && lunch BD_Nicola-userdebug && make -j48"
#CMD="rm -rf ./build && rm -rf ./sstate-cache && DATETIME=\`date '+%Y%m%d%H%M%S'\` && echo Builder_\$DATETIME > meta/poky/meta-firmware_version/recipes-bsp/bbversion/files/ver && export TEMPLATECONF=\${PWD}/meta/base/conf/mt8516/aud8516-emmc && source meta/poky/oe-init-build-env && echo PARALLEL_MAKE=\\\"-j 16\\\">>conf/local.conf && echo SECURE_BOOT_ENABLE = \\\"yes\\\" >> conf/local.conf && bitbake mtk-image-aud-8516 2>&1 | tee build.log"

#CMD="DATETIME=\`date '+%Y%m%d%H%M%S'\` && echo Builder_\$DATETIME > meta/poky/meta-firmware_version/recipes-bsp/bbversion/files/ver && export TEMPLATECONF=\${PWD}/meta/base/conf/mt8516/aud8516-emmc && source meta/poky/oe-init-build-env && echo PARALLEL_MAKE=\\\"-j 16\\\">>conf/local.conf && echo SECURE_BOOT_ENABLE = \\\"yes\\\" >> conf/local.conf && bitbake mtk-image-aud-8516 2>&1 | tee build.log"


docker run $OPTION asus/builder$DOCKER_IMAGE:latest /bin/sh -c "$CMD"
