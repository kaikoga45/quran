part of 'audio_player_bloc.dart';

sealed class AudioPlayerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AudioPlayerInitial extends AudioPlayerState {}

class AudioReady extends AudioPlayerState {}

class AudioPlaying extends AudioPlayerState {}

class AudioPaused extends AudioPlayerState {}

class AudioDurationLoaded extends AudioPlayerState {
  final double duration;
  AudioDurationLoaded(this.duration);

  @override
  List<Object?> get props => [duration];
}

class AudioPositionUpdated extends AudioPlayerState {
  final int position;
  AudioPositionUpdated(this.position);

  @override
  List<Object?> get props => [position];
}

class AudioError extends AudioPlayerState {
  final String message;
  AudioError(this.message);

  @override
  List<Object?> get props => [message];
}
