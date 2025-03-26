part of 'audio_player_bloc.dart';

sealed class AudioPlayerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SetupAudio extends AudioPlayerEvent {
  final String url;
  SetupAudio(this.url);
  @override
  List<Object?> get props => [url];
}

class PlayAudio extends AudioPlayerEvent {}

class PauseAudio extends AudioPlayerEvent {}

class SeekAudio extends AudioPlayerEvent {
  final int position;
  SeekAudio(this.position);

  @override
  List<Object?> get props => [position];
}

class ResetAction extends AudioPlayerEvent {}

class GetDuration extends AudioPlayerEvent {}

class GetCurrentPosition extends AudioPlayerEvent {}

class DisposeAudio extends AudioPlayerEvent {}
