import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quran/core/data/api/quran_api.dart';

import '../../../placeholder_data/detail_surah_placeholder_data.dart';
import '../../../placeholder_data/surah_placeholder_data.dart';
import '../../../mocks/mocks_data_test.mocks.dart';

void main() {
  late Dio dio;
  late QuranApi quranApi;

  setUp(() {
    dio = MockDio();
    quranApi = QuranApi(dio);
  });

  test('GetListSurah_CalledSuccessfully_ReturnsListSurahEntities', () async {
    when(
      dio.get(
        '${QuranApi.baseUrl}/${QuranApiEndpoint.surah.name}',
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(),
        data: SurahPlaceholderData.surahJson,
      ),
    );

    final listSurah = await quranApi.getListSurah();

    expect(listSurah, SurahPlaceholderData.listSurahEntities);
  });

  test('GetListSurah_CalledFailedServerUnavailable_ThrowsDioError', () async {
    when(
      dio.get(
        '${QuranApi.baseUrl}/${QuranApiEndpoint.surah.name}',
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(),
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: HttpStatus.internalServerError,
        ),
      ),
    );

    expect(
      () => quranApi.getListSurah(),
      throwsA(
        predicate((e) {
          return e is DioException &&
              e.response!.statusCode == HttpStatus.internalServerError;
        }),
      ),
    );
  });

  test('GetDetailSurah_SurahNumberOne_ReturnsDetailSurahEntities', () async {
    const int surahNumber = 1;
    when(
      dio.get(
        '${QuranApi.baseUrl}/${QuranApiEndpoint.surah.name}/$surahNumber',
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(),
        data: DetailSurahPlaceholderData.detailSurahJson,
      ),
    );

    final listSurah = await quranApi.getDetailSurah(surahNumber);

    expect(listSurah, DetailSurahPlaceholderData.detailSurahEntities);
  });

  test('GetDetailSurah_CalledFailedServerUnavailable_ThrowsDioError', () async {
    const int surahNumber = 1;

    when(
      dio.get(
        '${QuranApi.baseUrl}/${QuranApiEndpoint.surah.name}/$surahNumber',
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(),
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: HttpStatus.internalServerError,
        ),
      ),
    );

    expect(
      () => quranApi.getDetailSurah(surahNumber),
      throwsA(
        predicate((e) {
          return e is DioException &&
              e.response!.statusCode == HttpStatus.internalServerError;
        }),
      ),
    );
  });
}
