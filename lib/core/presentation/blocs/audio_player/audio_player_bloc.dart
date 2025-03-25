import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  static const MethodChannel _channel = MethodChannel('audio_player');
  Timer? _positionTimer; // Timer to update playback position

  AudioPlayerBloc() : super(AudioPlayerInitial()) {
    on<PlayAudio>((event, emit) async {
      try {
        await _channel.invokeMethod('play');
        emit(AudioPlaying());

        // Start updating playback position
        _startPositionUpdates();
      } on PlatformException catch (e) {
        emit(AudioError(e.message ?? "Error playing audio"));
      }
    });

    on<PauseAudio>((event, emit) async {
      try {
        await _channel.invokeMethod('pause');
        emit(AudioPaused());
        _positionTimer?.cancel(); // Stop updating position
      } on PlatformException catch (e) {
        emit(AudioError(e.message ?? "Error pausing audio"));
      }
    });

    on<SeekAudio>((event, emit) async {
      try {
        await _channel.invokeMethod('seekTo', {'position': event.position});
      } on PlatformException catch (e) {
        emit(AudioError(e.message ?? "Error seeking audio"));
      }
    });

    on<GetDuration>((event, emit) async {
      try {
        final duration = await _channel
                .invokeMethod<double>('getDuration', {'url': event.url}) ??
            0;
        emit(AudioDurationLoaded(duration));
      } on PlatformException catch (e) {
        emit(AudioError(e.message ?? "Error getting duration"));
      }
    });

    on<GetCurrentPosition>((event, emit) async {
      try {
        final position =
            await _channel.invokeMethod<double>('getCurrentPosition') ?? 0;
        emit(AudioPositionUpdated(position.toInt()));
      } on PlatformException catch (e) {
        emit(AudioError(e.message ?? "Error getting position"));
      }
    });
  }

  void _startPositionUpdates() {
    _positionTimer?.cancel(); // Cancel any existing timer
    _positionTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      add(GetCurrentPosition()); // Trigger event to get position
    });
  }

  @override
  Future<void> close() {
    _positionTimer?.cancel(); // Clean up timer
    _channel.invokeMethod('stop'); // Stop the audio
    return super.close();
  }
}
