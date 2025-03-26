import 'package:equatable/equatable.dart';

class DetailSurahEntities extends Equatable {
  final bool status;
  final int number;
  final String name;
  final String latinName;
  final int totalVerses;
  final String revelationPlace;
  final String meaning;
  final String description;
  final String audio;
  final List<Verse> verses;
  final ({NextSurah? nextSurah, bool status}) nextSurah;
  final ({NextSurah? previousSurah, bool status}) previousSurah;

  const DetailSurahEntities({
    required this.status,
    required this.number,
    required this.name,
    required this.latinName,
    required this.totalVerses,
    required this.revelationPlace,
    required this.meaning,
    required this.description,
    required this.audio,
    required this.verses,
    required this.nextSurah,
    required this.previousSurah,
  });

  factory DetailSurahEntities.fromJson(Map<String, dynamic> json) {
    return DetailSurahEntities(
      status: json['status'],
      number: json['nomor'],
      name: json['nama'],
      latinName: json['nama_latin'],
      totalVerses: json['jumlah_ayat'],
      revelationPlace: json['tempat_turun'],
      meaning: json['arti'],
      description: json['deskripsi'],
      audio: json['audio'],
      verses: (json['ayat'] as List<dynamic>)
          .map((e) => Verse.fromJson(e))
          .toList(),
      nextSurah: json['surat_selanjutnya'] is bool
          ? (nextSurah: null, status: false)
          : (
              nextSurah: NextSurah.fromJson(json['surat_selanjutnya']),
              status: true
            ),
      previousSurah: json['surat_sebelumnya'] is bool
          ? (previousSurah: null, status: false)
          : (
              previousSurah: NextSurah.fromJson(json['surat_sebelumnya']),
              status: true
            ),
    );
  }

  @override
  List<Object?> get props => [
        status,
        number,
        name,
        latinName,
        totalVerses,
        revelationPlace,
        meaning,
        description,
        audio,
        verses,
        nextSurah,
        previousSurah,
      ];
}

class Verse extends Equatable {
  final int id;
  final int surah;
  final int number;
  final String arabic;
  final String transliteration;
  final String translation;

  const Verse({
    required this.id,
    required this.surah,
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'],
      surah: json['surah'],
      number: json['nomor'],
      arabic: json['ar'],
      transliteration: json['tr'],
      translation: json['idn'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        surah,
        number,
        arabic,
        transliteration,
        translation,
      ];
}

class NextSurah extends Equatable {
  final int id;
  final int number;
  final String name;
  final String latinName;
  final int totalVerses;
  final String revelationPlace;
  final String meaning;
  final String description;
  final String audio;

  const NextSurah({
    required this.id,
    required this.number,
    required this.name,
    required this.latinName,
    required this.totalVerses,
    required this.revelationPlace,
    required this.meaning,
    required this.description,
    required this.audio,
  });

  factory NextSurah.fromJson(Map<String, dynamic> json) {
    return NextSurah(
      id: json['id'],
      number: json['nomor'],
      name: json['nama'],
      latinName: json['nama_latin'],
      totalVerses: json['jumlah_ayat'],
      revelationPlace: json['tempat_turun'],
      meaning: json['arti'],
      description: json['deskripsi'],
      audio: json['audio'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        number,
        name,
        latinName,
        totalVerses,
        revelationPlace,
        meaning,
        description,
        audio,
      ];
}
