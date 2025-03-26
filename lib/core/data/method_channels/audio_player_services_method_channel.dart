import 'package:flutter/services.dart';

enum AudioPlayerServicesAction {
  play,
  pause,
  seekTo,
  stop,
  getDuration,
  getCurrentPosition,
}

class AudioPlayerServicesMethodChannel {
  final MethodChannel _channel;

  AudioPlayerServicesMethodChannel(MethodChannel channel) : _channel = channel;

  Future<void> play() {
    return _channel.invokeMethod(AudioPlayerServicesAction.play.name);
  }

  Future<void> pause() {
    return _channel.invokeMethod(AudioPlayerServicesAction.pause.name);
  }

  Future<void> seek(int position) {
    return _channel.invokeMethod(AudioPlayerServicesAction.seekTo.name, {
      'position': position,
    });
  }

  Future<void> stop() {
    return _channel.invokeMethod(AudioPlayerServicesAction.stop.name);
  }

  Future<double> getDuration(String audioUrl) async {
    return await _channel
            .invokeMethod<double>(AudioPlayerServicesAction.getDuration.name, {
          'url': audioUrl,
        }) ??
        0.0;
  }

  Future<double> getCurrentPosition() async {
    return await _channel.invokeMethod<double>(
          AudioPlayerServicesAction.getCurrentPosition.name,
        ) ??
        0.0;
  }
}
