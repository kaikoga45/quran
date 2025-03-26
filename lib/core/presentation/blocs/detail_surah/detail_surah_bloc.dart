import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:quran/core/domain/entities/detail_surah_entities.dart';
import 'package:quran/core/domain/repositories/surah_repositories.dart';

part 'detail_surah_event.dart';
part 'detail_surah_state.dart';

class DetailSurahBloc extends Bloc<DetailSurahEvent, DetailSurahState> {
  final SurahRepositories _surahRepositories;

  DetailSurahBloc(SurahRepositories surahRepoositories)
      : _surahRepositories = surahRepoositories,
        super(DetailSurahInitial()) {
    on<GetDetailSurah>(_getDetailSurahHandler);
  }

  Future _getDetailSurahHandler(
    GetDetailSurah event,
    Emitter<DetailSurahState> emit,
  ) async {
    try {
      emit(DetailSurahLoading());
      final DetailSurahEntities detailSurah =
          await _surahRepositories.getDetailSurah(event.surahNumber);
      emit(DetailSurahLoaded(detailSurah));
    } on DioException catch (e) {
      emit(DetailSurahError(e.message ?? 'Error getting detail surah'));
    }
  }
}
