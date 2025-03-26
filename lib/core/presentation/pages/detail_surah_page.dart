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
        builder: (context, state) {
          return switch (state) {
            DetailSurahLoading _ => const LoadingWidget(),
            DetailSurahLoaded detailSurahLoaded =>
              LoadedDetailSurahPage(detailSurahLoaded.detailSurah),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}

class LoadedDetailSurahPage extends StatefulWidget {
  final DetailSurahEntities detailSurah;

  const LoadedDetailSurahPage(
    this.detailSurah, {
    super.key,
  });

  @override
  State<LoadedDetailSurahPage> createState() => _LoadedDetailSurahPageState();
}

class _LoadedDetailSurahPageState extends State<LoadedDetailSurahPage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late GlobalKey _audioPlayerKey;
  Timer? _scrollEndTimer;
  bool isFingerReleased = false;
  double heightAudioPlayer = 0.0;

  @override
  void initState() {
    super.initState();
    _audioPlayerKey = GlobalKey();
    _setHeightAudioPlayer();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scrollController.addListener(_onScroll);
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
            onPointerUp: (_) {
              isFingerReleased = true;
            },
            child: ListView.separated(
              controller: _scrollController,
              itemCount: widget.detailSurah.verses.length,
              itemBuilder: (context, index) {
                final verse = widget.detailSurah.verses[index];
                return VerseCard(
                  index: index,
                  verse: verse,
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: ColorConstant.osloGrey,
                  thickness: 0.3,
                );
              },
            ),
          ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset:
                    Offset(0, _animationController.value * heightAudioPlayer),
                child: AudioPlayerWidget(
                  key: _audioPlayerKey,
                  audioUrl: widget.detailSurah.audio,
                  title: widget.detailSurah.latinName,
                  subtitle: widget.detailSurah.revelationPlace,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onScroll() {
    _scrollEndTimer?.cancel();
    if ([ScrollDirection.forward, ScrollDirection.reverse]
        .contains(_scrollController.position.userScrollDirection)) {
      _animationController.forward();
      _setTimerResetAudioPlayerHeight();
    }
  }

  void _setTimerResetAudioPlayerHeight() {
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
          _audioPlayerKey.currentContext?.findRenderObject() as RenderBox;
      heightAudioPlayer = renderBox.size.height;
    });
  }
}
