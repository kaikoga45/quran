import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:quran/common/constants/locator_constant.dart';
import 'package:quran/common/constants/method_channel_constant.dart';
import 'package:quran/core/data/api/quran_api.dart';
import 'package:quran/core/data/method_channels/audio_player_services_method_channel.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator
    ..registerSingleton(Dio())
    // METHOD CHANNELS
    ..registerLazySingleton(
      () => const MethodChannel(MethodChannelConstant.audioPlayer),
      instanceName: LocatorConstant.audioPlayer.name,
    )
    ..registerLazySingleton(
      () => AudioPlayerServicesMethodChannel(
        locator<MethodChannel>(
          instanceName: LocatorConstant.audioPlayer.name,
        ),
      ),
    )
    // API'S
    ..registerLazySingleton(() => QuranApi(locator<Dio>()));
}
