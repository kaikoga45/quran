part of 'surah_bloc.dart';

sealed class SurahState extends Equatable {
  const SurahState();

  @override
  List<Object> get props => [];
}

final class SurahInitial extends SurahState {}

final class SurahLoading extends SurahState {}

final class SurahLoaded extends SurahState {
  final List<SurahEntities> listSurah;
  const SurahLoaded(this.listSurah);

  @override
  List<Object> get props => [listSurah];
}

final class SurahError extends SurahState {
  final String message;
  const SurahError(this.message);

  @override
  List<Object> get props => [message];
}
