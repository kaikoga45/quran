import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:quran/core/domain/repositories/audio_player_repositories.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  Timer? _positionTimer;

  final AudioPlayerRepositories _repositories;

  AudioPlayerBloc(AudioPlayerRepositories repositories)
      : _repositories = repositories,
        super(AudioPlayerInitial()) {
    on<ResetAction>((event, emit) {
      emit(AudioFinish());
    });
    on<SetupAudio>((event, emit) async {
      try {
        await _repositories.setup(event.url);
        emit(AudioReady());
      } on PlatformException catch (e) {
        emit(AudioError(e.message ?? "Error setup audio"));
      }
    });
    on<PlayAudio>((event, emit) async {
      try {
        await _repositories.play();
        emit(AudioPlaying());

        _startPositionUpdates();
      } on PlatformException catch (e) {
        emit(AudioError(e.message ?? "Error playing audio"));
      }
    });

    on<PauseAudio>((event, emit) async {
      try {
        await _repositories.pause();
        emit(AudioPaused());
        _positionTimer?.cancel();
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
        final duration = await _repositories.getDuration();
        emit(AudioDurationLoaded(duration));
      } on PlatformException catch (e) {
        emit(AudioError(e.message ?? "Error getting duration"));
      }
    });

    on<GetCurrentPosition>((event, emit) async {
      try {
        final double position = await _repositories.getCurrentPosition();
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
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      add(GetCurrentPosition());
    });
  }

  void _resetAudioPlayer() {
    _positionTimer?.cancel();
    _repositories.stop();
  }

  @override
  Future<void> close() {
    _resetAudioPlayer();
    return super.close();
  }
}
