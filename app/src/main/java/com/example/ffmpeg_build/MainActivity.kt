package com.example.ffmpeg_build

import android.annotation.SuppressLint
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.Html
import android.text.SpannableString
import android.text.TextUtils
import android.util.Log
import android.widget.TextView
import com.example.ffmpeg_build.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var tvVersion: TextView
    private lateinit var tvDecode: TextView
    private lateinit var tvEncode: TextView

    @SuppressLint("SetTextI18n")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        tvVersion = findViewById(R.id.version)
        tvDecode = findViewById(R.id.decoder)
        tvEncode = findViewById(R.id.encoder)

        tvVersion.text =
            "${Build.MODEL} ${Build.VERSION.SDK_INT}\n${getFFmpegVersion()}\n${Build.SUPPORTED_ABIS.contentToString()}"

        tvDecode.text =
            TextUtils.concat(Html.fromHtml("<b>Decoder:</b>"), getDecodes().contentToString())
        tvEncode.text =
            TextUtils.concat(Html.fromHtml("<b>Encoder:</b>"), getDecodes().contentToString())

    }

    private external fun getEncodes(): Array<String>

    private external fun getFFmpegVersion(): String

    private external fun getDecodes(): Array<String>

    companion object {
        private const val TAG = "MainActivity"

        init {
            System.loadLibrary("ffmpeg_build")
        }
    }

}