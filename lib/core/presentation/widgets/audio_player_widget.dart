import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/common/constants/color_constant.dart';
import 'package:quran/core/domain/repositories/audio_player_repositories.dart';
import 'package:quran/core/presentation/blocs/audio_player/audio_player_bloc.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final String title;
  final String subtitle;
  final (bool hasBackwardEnable, VoidCallback backwardCallback) backwardOptions;
  final (bool hasForwardEnable, VoidCallback forwardCallback) forwardOptions;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    required this.title,
    required this.subtitle,
    required this.backwardOptions,
    required this.forwardOptions,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayerBloc _audioPlayerBloc;

  double totalDuration = 1;
  double currentPosition = 0;
  bool isPlaying = false;
  bool isDragging = false;
  double dragPosition = 0;

  @override
  void initState() {
    _createAudioPlayerBloc();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AudioPlayerWidget oldWidget) {
    if (oldWidget.audioUrl != widget.audioUrl) _resetAudioPlayer();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _audioPlayerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _audioPlayerBloc,
      child: BlocConsumer<AudioPlayerBloc, AudioPlayerState>(
        listener: _listenerAudioPlayerBloc,
        builder: (context, state) {
          if (state is AudioError) return Text(state.message);

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(1),
                  Colors.black.withOpacity(1),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              color: () {
                                if (widget.backwardOptions.$1) {
                                  return Colors.white;
                                }
                                return ColorConstant.liver;
                              }(),
                              icon: const Icon(
                                CupertinoIcons.backward_fill,
                                size: 40,
                              ),
                              onPressed: _onPressedBackwardButton,
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(
                                isPlaying
                                    ? CupertinoIcons.pause_solid
                                    : CupertinoIcons.play_arrow_solid,
                                size: 40,
                              ),
                              onPressed: () {
                                if (isPlaying) {
                                  context
                                      .read<AudioPlayerBloc>()
                                      .add(PauseAudio());
                                } else {
                                  context
                                      .read<AudioPlayerBloc>()
                                      .add(PlayAudio());
                                }
                              },
                            ),
                            IconButton(
                              color: () {
                                if (widget.forwardOptions.$1) {
                                  return Colors.white;
                                }
                                return ColorConstant.liver;
                              }(),
                              icon: const Icon(
                                CupertinoIcons.forward_fill,
                                size: 40,
                              ),
                              onPressed: _onPressedForwardButton,
                            ),
                          ],
                        ),
                        CupertinoSlider(
                          thumbColor: ColorConstant.valentineRed,
                          activeColor: ColorConstant.valentineRed,
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
                            context
                                .read<AudioPlayerBloc>()
                                .add(SeekAudio(seekPosition));
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(currentPosition),
                              style: const TextStyle(
                                color: ColorConstant.osloGrey,
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              _formatDuration(totalDuration),
                              style: const TextStyle(
                                color: ColorConstant.osloGrey,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: const Icon(
                                CupertinoIcons.repeat,
                                size: 30,
                              ),
                              onPressed: () {
                                // TODO: Iimplement Repeat
                              },
                            ),
                          ],
                        ),
                        Text(
                          widget.subtitle,
                          style: const TextStyle(
                            color: ColorConstant.osloGrey,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onPressedBackwardButton() {
    if (!widget.backwardOptions.$1) return;
    widget.backwardOptions.$2.call();
  }

  void _onPressedForwardButton() {
    if (!widget.forwardOptions.$1) return;
    widget.forwardOptions.$2.call();
  }

  void _createAudioPlayerBloc() {
    final audioPlayerRepositories =
        RepositoryProvider.of<AudioPlayerRepositories>(context);
    _audioPlayerBloc = AudioPlayerBloc(audioPlayerRepositories)
      ..add(GetDuration(widget.audioUrl));
  }

  void _listenerAudioPlayerBloc(BuildContext context, AudioPlayerState state) {
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
  }

  void _resetAudioPlayer() {
    isPlaying = false;
    _audioPlayerBloc
      ..add(DisposeAudio())
      ..add(GetDuration(widget.audioUrl));
  }

  String _formatDuration(double duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(Duration(seconds: duration.toInt()).inMinutes)}:${twoDigits(Duration(seconds: duration.toInt()).inSeconds.remainder(60))}";
  }
}
