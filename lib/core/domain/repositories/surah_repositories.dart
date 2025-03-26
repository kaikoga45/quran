import 'package:quran/core/data/api/quran_api.dart';
import 'package:quran/core/domain/entities/detail_surah_entities.dart';
import 'package:quran/core/domain/entities/surah_entities.dart';

class SurahRepositories {
  final QuranApi _quranApi;

  SurahRepositories(QuranApi quranApi) : _quranApi = quranApi;

  Future<List<SurahEntities>> getListSurah() {
    return _quranApi.getListSurah();
  }

  Future<DetailSurahEntities> getDetailSurah(int surahNumber) {
    return _quranApi.getDetailSurah(surahNumber);
  }
}
