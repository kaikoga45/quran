import 'package:quran/core/data/method_channels/audio_player_services_method_channel.dart';

class AudioPlayerRepositories {
  final AudioPlayerServicesMethodChannel _channel;

  const AudioPlayerRepositories(AudioPlayerServicesMethodChannel channel)
      : _channel = channel;

  Future<void> setup(String url) {
    return _channel.setup(url);
  }

  Future<void> play() {
    return _channel.play();
  }

  Future<void> pause() {
    return _channel.pause();
  }

  Future<void> seek(int position) {
    return _channel.seek(position);
  }

  Future<void> stop() {
    return _channel.stop();
  }

  Future<double> getDuration() {
    return _channel.getDuration();
  }

  Future<double> getCurrentPosition() {
    return _channel.getCurrentPosition();
  }
}
