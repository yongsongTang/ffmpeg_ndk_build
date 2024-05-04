#!/bin/bash
# Run this from within a bash shell

#https://bitbucket.org/multicoreware/x265_git.git

# NDK
export NDK_PATH=/Users/tys/Library/Android/sdk/ndk/21.4.7075529
export PREBUILT=${NDK_PATH}/toolchains/llvm/prebuilt/darwin-x86_64

PLATFORM_VERSION=21

# x264 src
X265_SOURCE_PATH=../../x265_git
INSTALL_DIR=$(pwd)/build_x265/android
BUILD_OUTPUT=${PWD}/build_x265/build_dir
echo "output dir:${INSTALL_DIR}"

# 清空目录
if [[ -e ${INSTALL_DIR} ]]; then
    rm -rf "${INSTALL_DIR}"
fi

if [[ -e ${BUILD_OUTPUT} ]]; then
    rm -rf "${BUILD_OUTPUT}"
fi

function build_one(){

  cmake \
  -DCMAKE_TOOLCHAIN_FILE=${NDK_PATH}/build/cmake/android.toolchain.cmake \
  -DANDROID_ABI="$ARCH" \
  -DANDROID_PLATFORM=android-${PLATFORM_VERSION} \
  -DCMAKE_SYSTEM_NAME="android" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_ABSOLUTE_PATH}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DANDROID=1 \
  -DENABLE_ASSEMBLY=OFF \
  -DENABLE_NEON=ON \
  -DENABLE_SHARED=OFF \
  -DENABLE_PIC=ON \
  -DENABLE_CLI=OFF \
  "${OPTIONS_PARAMD}" \
  -B "${BUILD_DIR}" \
  -G "Unix Makefiles" ${X265_SOURCE_PATH}/source/  \

  sed -i '' 's/-lpthread/-pthread/' "${BUILD_DIR}"/CMakeFiles/x265-shared.dir/link.txt
  sed -i '' 's/-lpthread/-pthread/' "${BUILD_DIR}"/CMakeFiles/x265-static.dir/link.txt

  make -C "${BUILD_DIR}" && make -C "${BUILD_DIR}" install

}

#####arm64
INSTALL_ABSOLUTE_PATH=${INSTALL_DIR}/arm64-v8a
BUILD_DIR=${BUILD_OUTPUT}/arm64-v8a
ARCH=arm64-v8a

OPTIONS_PARAMD="-DCROSS_COMPILE_ARM64=1"
build_one


####armeabi-v7a
INSTALL_ABSOLUTE_PATH=${INSTALL_DIR}/armeabi-v7a
BUILD_DIR=${BUILD_OUTPUT}/armeabi-v7a
ARCH=armeabi-v7a

OPTIONS_PARAMD="-DCROSS_COMPILE_ARM=1"
build_one





