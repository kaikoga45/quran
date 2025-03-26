part of 'audio_player_bloc.dart';

sealed class AudioPlayerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class SetupAudio extends AudioPlayerEvent {
  final String url;
  SetupAudio(this.url);
  @override
  List<Object?> get props => [url];
}

final class PlayAudio extends AudioPlayerEvent {}

final class PauseAudio extends AudioPlayerEvent {}

final class SeekAudio extends AudioPlayerEvent {
  final int position;
  SeekAudio(this.position);

  @override
  List<Object?> get props => [position];
}

final class ResetAction extends AudioPlayerEvent {}

final class GetDuration extends AudioPlayerEvent {}

final class GetCurrentPosition extends AudioPlayerEvent {}

final class DisposeAudio extends AudioPlayerEvent {}
