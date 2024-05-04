#include <jni.h>
#include <string>
#include <vector>
#include <android/api-level.h>


extern "C" {
#include "libavcodec/version.h"
#include "libavcodec/avcodec.h"
#include "libavutil/version.h"
}
constexpr const char *TAG = "build_ffmpeg";


extern "C"
JNIEXPORT jstring JNICALL
Java_com_example_ffmpeg_1build_MainActivity_getFFmpegVersion(JNIEnv *env, jobject thiz) {
    const char *version = av_version_info();
    return env->NewStringUTF(version);
}

extern "C"
JNIEXPORT jobjectArray JNICALL
Java_com_example_ffmpeg_1build_MainActivity_getDecodes(JNIEnv *env, jobject thiz) {
    const AVCodec *codec = NULL;
    void *opaque = 0;
    std::vector<std::string> decoders{};
    while ((codec = av_codec_iterate(&opaque)) != NULL) {
        if (codec->type == AVMEDIA_TYPE_VIDEO && av_codec_is_decoder(codec)) {
            decoders.push_back(codec->name);
        }
    }

    unsigned long size = decoders.size();
    jclass stringClass = env->FindClass("java/lang/String");
    jobjectArray result = env->NewObjectArray(size, stringClass, NULL);

    for (int i = 0; i < size; ++i) {
        env->SetObjectArrayElement(
                result, i, env->NewStringUTF(decoders[i].c_str())
        );
    }
    return result;
}

extern "C"
JNIEXPORT jobjectArray JNICALL
Java_com_example_ffmpeg_1build_MainActivity_getEncodes(JNIEnv *env, jobject thiz) {
    const AVCodec *codec = NULL;
    void *opaque = 0;
    std::vector<std::string> decoders{};
    while ((codec = av_codec_iterate(&opaque)) != NULL) {
        if (codec->type == AVMEDIA_TYPE_VIDEO && av_codec_is_encoder(codec)) {
            decoders.push_back(codec->name);
        }
    }

    unsigned long size = decoders.size();
    jclass stringClass = env->FindClass("java/lang/String");
    jobjectArray result = env->NewObjectArray(size, stringClass, NULL);

    for (int i = 0; i < size; ++i) {
        env->SetObjectArrayElement(
                result, i, env->NewStringUTF(decoders[i].c_str())
        );
    }
    return result;
}