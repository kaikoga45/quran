package dev.kaikoga.quran.services

import android.media.MediaPlayer
import android.util.Patterns
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AudioPlayerService : MethodChannel.MethodCallHandler {
    private var mediaPlayer: MediaPlayer? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setup" -> {
                val url = call.argument<String>("url") ?: run {
                    result.error("NO_URL_PAYLOAD", "No URL provided in the payload", null)
                    return
                }
                if (!isValidUrl(url)) {
                    result.error("INVALID_URL", "Invalid audio URL", null)
                    return
                }

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
                val position = call.argument<Int>("position") ?: run {
                    result.error("NO_POSITION_PAYLOAD", "No position provided in the payload", null)
                    return
                }
                mediaPlayer?.seekTo(position)
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

    private fun isValidUrl(url: String): Boolean {
        return !url.isBlank() && Patterns.WEB_URL.matcher(url).matches()
    }
}