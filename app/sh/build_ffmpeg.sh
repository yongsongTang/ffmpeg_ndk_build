#!/bin/bash

#git@github.com:FFmpeg/FFmpeg.git

# NDK
export NDK_PATH=/Users/tys/Library/Android/sdk/ndk/21.4.7075529
export PREBUILT=${NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64

# ffmpeg
FFMPEG_SOURCE_PATH=../../FFmpeg
PLATFORM_VERSION=21

# 安装目录
INSTALL_PATH=${PWD}/build_ffmpeg
echo "output dir:${INSTALL_PATH}"

function build_one(){
  cd $FFMPEG_SOURCE_PATH || exit
  make clean

  ./configure --prefix="${INSTALL_DIR}" \
  --target-os=android \
	--enable-cross-compile \
	--cc="${CC}" \
	--nm="${NM}" \
	--ar="${AR}" \
  --yasmexe=${PREBUILT}/bin/yasm \
  --arch="${TARGET_ARCH}" \
  --enable-stripping \
  --enable-pic \
  --sysroot="${PREBUILT}/sysroot" \
  --cross-prefix="${CROSS_PREFIX}" \
  --extra-cflags="${INCLUDES} -Wl,-Bsymbolic -Os -DANDROID ${OPTIMIZE_CFLAGS} --static" \
  --extra-ldflags="${LIBS} -Wl,-Bsymbolic -Wl,-nostdlib -lc -lm -ldl -llog" \
  --pkg-config="pkg-config --static" \
  --extra-libs="-lx264 -lx265" \
  --disable-shared \
  --enable-static \
  --enable-gpl \
  --enable-libx264 \
  --enable-libx265 \
  "$ADDITIONAL_CONFIGURE_FLAG" \

  make -j8 install
  echo "=======${INSTALL_DIR}======="
  cd - || exit
}

#extra lib

# x264
X264_PATH=${PWD}/build_x264/android
# x265
X265_PATH=${PWD}/build_x265/android

###==================================================###

######arm64-v8a
TARGET_ARCH=arm64
INSTALL_DIR=./android/arm64-v8a

INCLUDES=" -I${X264_PATH}/arm64-v8a/include -I${X265_PATH}/arm64-v8a/include"
LIBS=" -L${X264_PATH}/arm64-v8a/lib -L${X265_PATH}/arm64-v8a/lib"
PKG_CFG_PATH="${X264_PATH}/arm64-v8a/lib/pkgconfig:${X265_PATH}/arm64-v8a/lib/pkgconfig"

LD=$PREBUILT/bin/aarch64-linux-android-ld
AR=$PREBUILT/bin/aarch64-linux-android-ar
NM=$PREBUILT/bin/aarch64-linux-android-nm
CC=${PREBUILT}/bin/aarch64-linux-android${PLATFORM_VERSION}-clang
CXX=${PREBUILT}/bin/aarch64-linux-android${PLATFORM_VERSION}-clang++
CROSS_PREFIX=$PREBUILT/bin/aarch64-linux-android-
OPTIMIZE_CFLAGS=
ADDITIONAL_CONFIGURE_FLAG="--enable-neon"
export PKG_CONFIG_PATH=${PKG_CFG_PATH}
build_one

######arm v7a
TARGET_ARCH=arm
INSTALL_DIR=./android/armeabi-v7a

INCLUDES=" -I${X264_PATH}/armeabi-v7a/include -I${X265_PATH}/armeabi-v7a/include"
LIBS=" -L${X264_PATH}/armeabi-v7a/lib -L${X265_PATH}/armeabi-v7a/lib"
PKG_CFG_PATH="${X264_PATH}/armeabi-v7a/lib/pkgconfig:${X265_PATH}/armeabi-v7a/lib/pkgconfig"

LD=$PREBUILT/bin/arm-linux-androideabi-ld
AR=$PREBUILT/bin/arm-linux-androideabi-ar
NM=$PREBUILT/bin/arm-linux-androideabi-nm
AS=$PREBUILT/bin/arm-linux-androideabi-as
CC=$PREBUILT/bin/armv7a-linux-androideabi${PLATFORM_VERSION}-clang
CXX=$PREBUILT/bin/armv7a-linux-androideabi${PLATFORM_VERSION}-clang++
CROSS_PREFIX=$PREBUILT/bin/arm-linux-androideabi-
OPTIMIZE_CFLAGS=
ADDITIONAL_CONFIGURE_FLAG="--enable-neon"
export PKG_CONFIG_PATH=${PKG_CFG_PATH}
build_one



# 检查目录是否存在
if [ ! -d "${INSTALL_PATH}" ]; then
    mkdir -p "${INSTALL_PATH}"
else
    if [[ -e ${INSTALL_PATH}/android ]]; then
          rm -rf "${INSTALL_PATH}"/android
    fi
fi

mv ${FFMPEG_SOURCE_PATH}/android/ "${INSTALL_PATH}"