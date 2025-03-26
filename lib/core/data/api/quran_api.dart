import 'package:dio/dio.dart';
import 'package:quran/core/domain/entities/detail_surah_entities.dart';
import 'package:quran/core/domain/entities/surah_entities.dart';

enum QuranApiEndpoint {
  surah,
}

class QuranApi {
  final Dio _dio;

  QuranApi(Dio dio) : _dio = dio;

  static const String baseUrl = 'https://open-api.my.id/api/quran';

  Future<List<SurahEntities>> getListSurah() async {
    final Response<dynamic> surahResponse =
        await _dio.get('$baseUrl/${QuranApiEndpoint.surah.name}');

    return List<SurahEntities>.from(
      surahResponse.data.map(
        (surah) => SurahEntities.fromJson(surah),
      ),
    );
  }

  Future<DetailSurahEntities> getDetailSurah(int surahNumber) async {
    final Response<dynamic> detailSurahResponse =
        await _dio.get('$baseUrl/${QuranApiEndpoint.surah.name}/$surahNumber');
    return DetailSurahEntities.fromJson(detailSurahResponse.data);
  }
}
