cmake_minimum_required(VERSION 3.22.1)

project("ffmpeg_build")

include_directories(
        ffmpeg/include
)

add_library(${CMAKE_PROJECT_NAME} SHARED
        native-lib.cpp)

set(ffmpeg_lib_dir ${CMAKE_CURRENT_SOURCE_DIR}/ffmpeg/lib/${CMAKE_ANDROID_ARCH_ABI})


target_link_libraries(${CMAKE_PROJECT_NAME}
        android
        log
        ${ffmpeg_lib_dir}/libavcodec.a
        ${ffmpeg_lib_dir}/libavdevice.a
        ${ffmpeg_lib_dir}/libavfilter.a
        ${ffmpeg_lib_dir}/libavformat
        ${ffmpeg_lib_dir}/libavutil.a
        ${ffmpeg_lib_dir}/libpostproc.a
        ${ffmpeg_lib_dir}/libswresample.a
        ${ffmpeg_lib_dir}/libswscale.a
        z

        ${CMAKE_CURRENT_SOURCE_DIR}/x264/lib/${CMAKE_ANDROID_ARCH_ABI}/libx264.a
        ${CMAKE_CURRENT_SOURCE_DIR}/x265/lib/${CMAKE_ANDROID_ARCH_ABI}/libx265.a
)

