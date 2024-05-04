#!/bin/bash

#git@github.com:mirror/x264.git

# NDK
export NDK_PATH=/Users/tys/Library/Android/sdk/ndk/21.4.7075529
export PREBUILT=${NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64

# x264
export X264_SOURCE_PATH=../../x264

PLATFORM_VERSION=21

# 安装目录
INSTALL_DIR=$(pwd)/build_x264/android
echo "output dir:${INSTALL_DIR}"

# 清空目录
if [[ -e ${INSTALL_DIR} ]]; then
    rm -rf "${INSTALL_DIR}"
fi

function build_one(){
  cd ${X264_SOURCE_PATH} || exit
  make clean

  export CC=$CC
  export CXX=$CXX

  ./configure \
  --prefix="${INSTALL_ABSOLUTE_PATH}" \
  --host="${TARGET_ARCH}-linux" \
  --cross-prefix="${CROSS_PREFIX}" \
  --sysroot=${PREBUILT}/sysroot \
  --enable-static \
  --enable-pic \
  --disable-cli \
  --disable-asm \
  --extra-cflags="-fPIC -DANDROID" \

  make -j8 install
  cd - || exit
}


#arm64-v8a
TARGET_ARCH=arm64
INSTALL_ABSOLUTE_PATH=${INSTALL_DIR}/arm64-v8a

CC=${PREBUILT}/bin/aarch64-linux-android${PLATFORM_VERSION}-clang
CXX=${PREBUILT}/bin/aarch64-linux-android${PLATFORM_VERSION}-clang++
CROSS_PREFIX=$PREBUILT/bin/aarch64-linux-android-
build_one


#arm v7a
TARGET_ARCH=arm
INSTALL_ABSOLUTE_PATH=${INSTALL_DIR}/armeabi-v7a

CC=$PREBUILT/bin/armv7a-linux-androideabi${PLATFORM_VERSION}-clang
CXX=$PREBUILT/bin/armv7a-linux-androideabi${PLATFORM_VERSION}-clang++
CROSS_PREFIX=$PREBUILT/bin/arm-linux-androideabi-
build_one

