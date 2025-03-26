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
  final VoidCallback onReadyCallback;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    required this.title,
    required this.subtitle,
    required this.backwardOptions,
    required this.forwardOptions,
    required this.onReadyCallback,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayerBloc _audioPlayerBloc;

  double totalDuration = 1;
  double currentPosition = 0;
  bool isPlaying = false;
  bool isDraggingSlider = false;
  double dragPosition = 0;
  bool isLooping = false;

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
          if (state is AudioPlayerInitial || State is AudioError) {
            return const SizedBox.shrink();
          }

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
                              onPressed: () => onPressedPlayButton(context),
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
                              ? (isDraggingSlider
                                      ? dragPosition
                                      : currentPosition) /
                                  totalDuration
                              : 0.0,
                          onChanged: (value) {
                            setState(() {
                              isDraggingSlider = true;
                              dragPosition = value * totalDuration;
                              currentPosition = dragPosition;
                            });
                          },
                          onChangeEnd: (value) {
                            setState(() {
                              isDraggingSlider = false;
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
                              color: () {
                                if (isLooping) {
                                  return Colors.white;
                                }
                                return ColorConstant.liver;
                              }(),
                              icon: const Icon(
                                CupertinoIcons.repeat,
                                size: 30,
                              ),
                              onPressed: () => setState(
                                () => isLooping = !isLooping,
                              ),
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

  void onPressedPlayButton(BuildContext context) {
    final AudioPlayerBloc audioPlayerBloc = context.read<AudioPlayerBloc>();
    if (isPlaying) {
      audioPlayerBloc.add(PauseAudio());
    } else {
      if (_isAudioFinish()) {
        audioPlayerBloc.add(SeekAudio(0));
      }
      audioPlayerBloc.add(PlayAudio());
    }
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
      ..add(SetupAudio(widget.audioUrl));
  }

  void _listenerAudioPlayerBloc(BuildContext context, AudioPlayerState state) {
    if (state is AudioReady) {
      widget.onReadyCallback.call();
      context.read<AudioPlayerBloc>().add(GetDuration());
    }
    if (state is AudioDurationLoaded) {
      totalDuration = state.duration;
    }
    if (state is AudioPositionUpdated && !isDraggingSlider) {
      currentPosition = state.position.toDouble();
      _listenerAudioFinish(context);
    }
    if (state is AudioPlaying) {
      isPlaying = true;
    }
    if (state is AudioPaused || state is AudioFinish) {
      isPlaying = false;
    }
  }

  bool _isAudioFinish() {
    return currentPosition.floor() == totalDuration.floor();
  }

  void _listenerAudioFinish(BuildContext context) {
    final AudioPlayerBloc audioPlayerBloc = context.read<AudioPlayerBloc>();

    if (!_isAudioFinish()) return;
    if (isLooping) {
      audioPlayerBloc
        ..add(SeekAudio(0))
        ..add(PlayAudio());
    } else {
      audioPlayerBloc.add(ResetAction());
    }
  }

  void _resetAudioPlayer() {
    isPlaying = false;
    _audioPlayerBloc
      ..add(DisposeAudio())
      ..add(SetupAudio(widget.audioUrl));
  }

  String _formatDuration(double duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(Duration(seconds: duration.toInt()).inMinutes)}:${twoDigits(Duration(seconds: duration.toInt()).inSeconds.remainder(60))}";
  }
}
