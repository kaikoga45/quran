import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/common/helpers/locator/service_locator_helper.dart';
import 'package:quran/core/data/api/quran_api.dart';
import 'package:quran/core/data/method_channels/audio_player_services_method_channel.dart';
import 'package:quran/core/domain/repositories/audio_player_repositories.dart';
import 'package:quran/core/domain/repositories/surah_repositories.dart';

final repositoriesProvider = [
  RepositoryProvider<AudioPlayerRepositories>(
    create: (_) =>
        AudioPlayerRepositories(locator<AudioPlayerServicesMethodChannel>()),
  ),
  RepositoryProvider<SurahRepositories>(
    create: (_) => SurahRepositories(locator<QuranApi>()),
  ),
];
