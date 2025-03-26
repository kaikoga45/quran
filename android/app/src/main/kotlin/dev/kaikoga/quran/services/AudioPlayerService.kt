package dev.kaikoga.quran.services

import android.media.MediaPlayer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AudioPlayerService : MethodChannel.MethodCallHandler {
    private var mediaPlayer: MediaPlayer? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setup" -> {
                val url = call.argument<String>("url") ?: return
                mediaPlayer = MediaPlayer().apply {
                    setDataSource(url)
                    prepare()
                }
                result.success(null)
            }
            "play" -> {
                mediaPlayer?.start()
                result.success(null)
            }
            "pause" -> {
                mediaPlayer?.pause()
                result.success(null)
            }
            "seekTo" -> {
                val position = call.argument<Double>("position") ?: 0.0
                mediaPlayer?.seekTo(position.toInt())
                result.success(null)
            }
            "stop" -> {
                mediaPlayer?.stop()
                mediaPlayer?.release()
                mediaPlayer = null
                result.success(null)
            }
            "getDuration" -> result.success(mediaPlayer?.duration?.toDouble()?.div(1000.0) ?: 0.0)
            "getCurrentPosition" -> result.success(mediaPlayer?.currentPosition?.toDouble()?.div(1000.0) ?: 0.0)
            else -> result.notImplemented()
        }
    }
}