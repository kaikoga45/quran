part of 'audio_player_bloc.dart';

sealed class AudioPlayerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlayAudio extends AudioPlayerEvent {}

class PauseAudio extends AudioPlayerEvent {}

class SeekAudio extends AudioPlayerEvent {
  final int position;
  SeekAudio(this.position);

  @override
  List<Object?> get props => [position];
}

class GetDuration extends AudioPlayerEvent {
  final String url;
  GetDuration(this.url);

  @override
  List<Object?> get props => [url];
}

class GetCurrentPosition extends AudioPlayerEvent {}
