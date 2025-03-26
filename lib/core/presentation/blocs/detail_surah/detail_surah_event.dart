part of 'detail_surah_bloc.dart';

sealed class DetailSurahEvent extends Equatable {
  const DetailSurahEvent();

  @override
  List<Object> get props => [];
}

final class GetDetailSurah extends DetailSurahEvent {
  final int surahNumber;
  const GetDetailSurah(this.surahNumber);
  @override
  List<Object> get props => [surahNumber];
}
