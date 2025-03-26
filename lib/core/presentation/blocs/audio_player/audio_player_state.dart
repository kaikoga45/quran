part of 'audio_player_bloc.dart';

sealed class AudioPlayerState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AudioPlayerInitial extends AudioPlayerState {}

final class AudioReady extends AudioPlayerState {}

final class AudioPlaying extends AudioPlayerState {}

final class AudioPaused extends AudioPlayerState {}

final class AudioDurationLoaded extends AudioPlayerState {
  final double duration;
  AudioDurationLoaded(this.duration);

  @override
  List<Object?> get props => [duration];
}

final class AudioPositionUpdated extends AudioPlayerState {
  final int position;
  AudioPositionUpdated(this.position);

  @override
  List<Object?> get props => [position];
}

final class AudioFinish extends AudioPlayerState {}

final class AudioError extends AudioPlayerState {
  final String message;
  AudioError(this.message);

  @override
  List<Object?> get props => [message];
}
