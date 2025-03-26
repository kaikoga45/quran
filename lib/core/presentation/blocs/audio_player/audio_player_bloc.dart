import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:quran/core/domain/repositories/audio_player_repositories.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  Timer? _positionTimer; // Timer to update playback position

  final AudioPlayerRepositories _repositories;

  AudioPlayerBloc(AudioPlayerRepositories repositories)
      : _repositories = repositories,
        super(AudioPlayerInitial()) {
    on<PlayAudio>((event, emit) async {
      try {
        await _repositories.play();
        emit(AudioPlaying());
        // Start updating playback position
        _startPositionUpdates();
      } on PlatformException catch (e) {
        emit(AudioError(e.message ?? "Error playing audio"));
      }
    });

    on<PauseAudio>((event, emit) async {
      try {
        await _repositories.pause();
        emit(AudioPaused());
        _positionTimer?.cancel(); // Stop updating position
      } on PlatformException catch (e) {
        emit(AudioError(e.message ?? "Error pausing audio"));
      }
    });

    on<SeekAudio>((event, emit) async {
      try {
        await _repositories.seek(event.position);
      } on PlatformException catch (e) {
        emit(AudioError(e.message ?? "Error seeking audio"));
      }
    });

    on<GetDuration>((event, emit) async {
      try {
        final duration = await _repositories.getDuration(event.url);
        emit(AudioDurationLoaded(duration));
      } on PlatformException catch (e) {
        emit(AudioError(e.message ?? "Error getting duration"));
      }
    });

    on<GetCurrentPosition>((event, emit) async {
      try {
        final position = await _repositories.getCurrentPosition();
        emit(AudioPositionUpdated(position.toInt()));
      } on PlatformException catch (e) {
        emit(AudioError(e.message ?? "Error getting position"));
      }
    });

    on<DisposeAudio>(
      (_, __) => _resetAudioPlayer(),
    );
  }

  void _startPositionUpdates() {
    _positionTimer?.cancel(); // Cancel any existing timer
    _positionTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      add(GetCurrentPosition()); // Trigger event to get position
    });
  }

  void _resetAudioPlayer() {
    _positionTimer?.cancel(); // Clean up timer
    _repositories.stop(); // Stop the audio
  }

  @override
  Future<void> close() {
    _resetAudioPlayer();
    return super.close();
  }
}
