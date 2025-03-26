class DetailSurahEntities {
  bool status;
  int number;
  String name;
  String latinName;
  int totalVerses;
  String revelationPlace;
  String meaning;
  String description;
  String audio;
  List<Verse> verses;
  ({NextSurah? nextSurah, bool? status}) nextSurah;
  ({NextSurah? previousSurah, bool? status}) previousSurah;

  DetailSurahEntities({
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
}

class Verse {
  int id;
  int surah;
  int number;
  String arabic;
  String transliteration;
  String translation;

  Verse({
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
}

class NextSurah {
  int id;
  int number;
  String name;
  String latinName;
  int totalVerses;
  String revelationPlace;
  String meaning;
  String description;
  String audio;

  NextSurah({
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
}
