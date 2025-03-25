import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/core/presentation/blocs/audio_player/audio_player_bloc.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  double totalDuration = 1;
  double currentPosition = 0;
  bool isPlaying = false;
  bool isDragging = false;
  double dragPosition = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AudioPlayerBloc()..add(GetDuration(widget.audioUrl)),
      child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
        builder: (context, state) {
          if (state is AudioDurationLoaded) {
            totalDuration = state.duration;
          }
          if (state is AudioPositionUpdated && !isDragging) {
            currentPosition = state.position.toDouble();
          }
          if (state is AudioPlaying) {
            isPlaying = true;
          }
          if (state is AudioPaused) {
            isPlaying = false;
          }

          return Column(
            children: [
              Slider(
                min: 0,
                value: totalDuration > 0
                    ? (isDragging ? dragPosition : currentPosition) /
                        totalDuration
                    : 0.0,
                onChanged: (value) {
                  setState(() {
                    isDragging = true;
                    dragPosition = value * totalDuration;
                    currentPosition = dragPosition;
                  });
                },
                onChangeEnd: (value) {
                  setState(() {
                    isDragging = false;
                  });
                  final int seekPosition = (value *
                          Duration(seconds: totalDuration.toInt())
                              .inMilliseconds)
                      .toInt();
                  context.read<AudioPlayerBloc>().add(SeekAudio(seekPosition));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(currentPosition)),
                  Text(_formatDuration(totalDuration)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () {
                      if (isPlaying) {
                        context.read<AudioPlayerBloc>().add(PauseAudio());
                      } else {
                        context.read<AudioPlayerBloc>().add(PlayAudio());
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDuration(double duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(Duration(seconds: duration.toInt()).inMinutes)}:${twoDigits(Duration(seconds: duration.toInt()).inSeconds.remainder(60))}";
  }
}
