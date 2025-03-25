package dev.kaikoga.quran.services

import android.media.MediaPlayer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AudioPlayerService : MethodChannel.MethodCallHandler {
    private var mediaPlayer: MediaPlayer? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "play" -> {
                val url = call.argument<String>("url") ?: return
                playAudio(url)
                result.success(null)
            }
            "pause" -> {
                mediaPlayer?.pause()
                result.success(null)
            }
            "seekTo" -> {
                val position = call.argument<Int>("position") ?: 0
                mediaPlayer?.seekTo(position)
                result.success(null)
            }
            "stop" -> {
                mediaPlayer?.stop()
                mediaPlayer?.release()
                mediaPlayer = null
                result.success(null)
            }
            "getDuration" -> result.success(mediaPlayer?.duration ?: 0)
            "getCurrentPosition" -> result.success(mediaPlayer?.currentPosition ?: 0)
            else -> result.notImplemented()
        }
    }

    private fun playAudio(url: String) {
        if (mediaPlayer == null) {
            mediaPlayer = MediaPlayer().apply {
                setDataSource(url)
                prepare()
                start()
            }
        } else {
            mediaPlayer?.start()
        }
    }
}