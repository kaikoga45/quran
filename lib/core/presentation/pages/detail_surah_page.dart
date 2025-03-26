import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/common/constants/color_constant.dart';
import 'package:quran/core/domain/entities/detail_surah_entities.dart';
import 'package:quran/core/domain/repositories/surah_repositories.dart';
import 'package:quran/core/presentation/blocs/detail_surah/detail_surah_bloc.dart';
import 'package:quran/core/presentation/widgets/audio_player_widget.dart';
import 'package:quran/core/presentation/widgets/loading_widget.dart';
import 'package:quran/core/presentation/widgets/verse_card_widget.dart';

class DetailSurahPage extends StatelessWidget {
  const DetailSurahPage({super.key});

  @override
  Widget build(BuildContext context) {
    final surahNumber = ModalRoute.of(context)?.settings.arguments as int;
    return BlocProvider(
      create: (context) {
        final surahRepoositories =
            RepositoryProvider.of<SurahRepositories>(context);
        return DetailSurahBloc(surahRepoositories)
          ..add(GetDetailSurah(surahNumber));
      },
      child: BlocBuilder<DetailSurahBloc, DetailSurahState>(
        builder: (context, state) => switch (state) {
          DetailSurahLoading _ => const LoadingWidget(),
          DetailSurahLoaded detailSurahLoaded => LoadedDetailSurahPage(
              detailSurahLoaded.detailSurah,
              backwardCallback: () {
                final int newSurahNumber = detailSurahLoaded
                    .detailSurah.previousSurah.previousSurah!.number;
                context
                    .read<DetailSurahBloc>()
                    .add(ChangeDetailSurah(newSurahNumber));
              },
              forwardCallback: () {
                final int newSurahNumber =
                    detailSurahLoaded.detailSurah.nextSurah.nextSurah!.number;
                context
                    .read<DetailSurahBloc>()
                    .add(ChangeDetailSurah(newSurahNumber));
              },
            ),
          _ => const SizedBox(),
        },
      ),
    );
  }
}

class LoadedDetailSurahPage extends StatefulWidget {
  final DetailSurahEntities detailSurah;
  final VoidCallback backwardCallback;
  final VoidCallback forwardCallback;

  const LoadedDetailSurahPage(
    this.detailSurah, {
    required this.backwardCallback,
    required this.forwardCallback,
    super.key,
  });

  @override
  State<LoadedDetailSurahPage> createState() => _LoadedDetailSurahPageState();
}

class _LoadedDetailSurahPageState extends State<LoadedDetailSurahPage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late GlobalKey _audioPlayerKeyWidget;
  Timer? _scrollEndTimer;
  bool isFingerReleased = false;
  double heightAudioPlayerWidget = 0.0;

  @override
  void initState() {
    super.initState();
    _audioPlayerKeyWidget = GlobalKey();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scrollController.addListener(_onScrollListVerse);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    _scrollEndTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.detailSurah.name,
          style: const TextStyle(
            fontSize: 33.0,
            color: ColorConstant.valentineRed,
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Listener(
            onPointerUp: (_) => isFingerReleased = true,
            child: ListView.separated(
              controller: _scrollController,
              itemCount: widget.detailSurah.verses.length,
              itemBuilder: (_, index) {
                final verse = widget.detailSurah.verses[index];
                return VerseCard(
                  index: index,
                  verse: verse,
                );
              },
              separatorBuilder: (_, __) {
                return const Divider(
                  color: ColorConstant.osloGrey,
                  thickness: 0.3,
                );
              },
            ),
          ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (_, __) {
              return Transform.translate(
                offset: Offset(
                  0,
                  _animationController.value * heightAudioPlayerWidget,
                ),
                child: AudioPlayerWidget(
                  key: _audioPlayerKeyWidget,
                  audioUrl: widget.detailSurah.audio,
                  title: widget.detailSurah.latinName,
                  subtitle: widget.detailSurah.revelationPlace,
                  backwardOptions: (
                    widget.detailSurah.previousSurah.status,
                    () => widget.backwardCallback.call(),
                  ),
                  forwardOptions: (
                    widget.detailSurah.nextSurah.status,
                    () => widget.forwardCallback.call(),
                  ),
                  onReady: _setHeightAudioPlayer,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onScrollListVerse() {
    _scrollEndTimer?.cancel();
    if ([ScrollDirection.forward, ScrollDirection.reverse]
        .contains(_scrollController.position.userScrollDirection)) {
      _animationController.forward();
      _setTimerResetAudioPlayerWidgetHeight();
    }
  }

  void _setTimerResetAudioPlayerWidgetHeight() {
    _scrollEndTimer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!isFingerReleased) return;
      isFingerReleased = false;
      timer.cancel();
      _animationController.reverse();
    });
  }

  void _setHeightAudioPlayer() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _audioPlayerKeyWidget.currentContext?.findRenderObject() as RenderBox;
      heightAudioPlayerWidget = renderBox.size.height;
    });
  }
}
