import 'package:flutter/services.dart';

enum AudioPlayerServicesAction {
  setup,
  play,
  pause,
  seekTo,
  stop,
  getDuration,
  getCurrentPosition,
}

class AudioPlayerServicesMethodChannel {
  final MethodChannel _methodChannel;

  AudioPlayerServicesMethodChannel(MethodChannel channel)
      : _methodChannel = channel;

  Future<void> setup(String url) {
    return _methodChannel.invokeMethod(
      AudioPlayerServicesAction.setup.name,
      {'url': url},
    );
  }

  Future<void> play() {
    return _methodChannel.invokeMethod(AudioPlayerServicesAction.play.name);
  }

  Future<void> pause() {
    return _methodChannel.invokeMethod(AudioPlayerServicesAction.pause.name);
  }

  Future<void> seek(int position) {
    return _methodChannel.invokeMethod(AudioPlayerServicesAction.seekTo.name, {
      'position': position,
    });
  }

  Future<void> stop() {
    return _methodChannel.invokeMethod(AudioPlayerServicesAction.stop.name);
  }

  Future<double> getDuration() async {
    return await _methodChannel
            .invokeMethod<double>(AudioPlayerServicesAction.getDuration.name) ??
        0.0;
  }

  Future<double> getCurrentPosition() async {
    return await _methodChannel.invokeMethod<double>(
          AudioPlayerServicesAction.getCurrentPosition.name,
        ) ??
        0.0;
  }
}
