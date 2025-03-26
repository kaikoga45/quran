import 'package:equatable/equatable.dart';

class SurahEntities extends Equatable {
  final int number;
  final String name;
  final String latinName;
  final int numberOfVerses;
  final String placeOfRevelation;
  final String meaning;
  final String description;
  final String audio;

  const SurahEntities({
    required this.number,
    required this.name,
    required this.latinName,
    required this.numberOfVerses,
    required this.placeOfRevelation,
    required this.meaning,
    required this.description,
    required this.audio,
  });

  factory SurahEntities.fromJson(Map<String, dynamic> json) {
    return SurahEntities(
      number: json['nomor'],
      name: json['nama'],
      latinName: json['nama_latin'],
      numberOfVerses: json['jumlah_ayat'],
      placeOfRevelation: json['tempat_turun'],
      meaning: json['arti'],
      description: json['deskripsi'],
      audio: json['audio'],
    );
  }

  @override
  List<Object?> get props => [
        number,
        name,
        latinName,
        numberOfVerses,
        placeOfRevelation,
        meaning,
        description,
        audio,
      ];
}
