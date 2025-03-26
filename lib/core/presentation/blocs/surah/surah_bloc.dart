import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:quran/core/domain/entities/surah_entities.dart';
import 'package:quran/core/domain/repositories/surah_repositories.dart';

part 'surah_event.dart';
part 'surah_state.dart';

class SurahBloc extends Bloc<SurahEvent, SurahState> {
  final SurahRepositories _surahRepositories;

  SurahBloc(SurahRepositories surahRepositories)
      : _surahRepositories = surahRepositories,
        super(SurahInitial()) {
    on<GetSurah>(_getSurahHandler);
  }

  Future _getSurahHandler(GetSurah event, Emitter<SurahState> emit) async {
    try {
      emit(SurahLoading());
      final List<SurahEntities> listSurah =
          await _surahRepositories.getListSurah();
      emit(SurahLoaded(listSurah));
    } on DioException catch (e) {
      emit(SurahError(e.message ?? 'Error getting surah'));
    }
  }
}
