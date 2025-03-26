import 'package:quran/core/domain/entities/surah_entities.dart';

class SurahPlaceholderData {
  static const List<Map<String, dynamic>> surahJson = [
    {
      "nomor": 1,
      "nama": "الفاتحة",
      "nama_latin": "Al-Fatihah",
      "jumlah_ayat": 7,
      "tempat_turun": "mekah",
      "arti": "Pembukaan",
      "deskripsi":
          "Surat \u003Ci\u003EAl Faatihah\u003C/i\u003E (Pembukaan) yang diturunkan di Mekah dan terdiri dari 7 ayat adalah surat yang pertama-tama diturunkan dengan lengkap  diantara surat-surat yang ada dalam Al Quran dan termasuk golongan surat Makkiyyah. Surat ini disebut \u003Ci\u003EAl Faatihah\u003C/i\u003E (Pembukaan), karena dengan surat inilah dibuka dan dimulainya Al Quran. Dinamakan \u003Ci\u003EUmmul Quran\u003C/i\u003E (induk Al Quran) atau \u003Ci\u003EUmmul Kitaab\u003C/i\u003E (induk Al Kitaab) karena dia merupakan induk dari semua isi Al Quran, dan karena itu diwajibkan membacanya pada tiap-tiap sembahyang.\u003Cbr\u003E Dinamakan pula \u003Ci\u003EAs Sab'ul matsaany\u003C/i\u003E (tujuh yang berulang-ulang) karena ayatnya tujuh dan dibaca berulang-ulang dalam sholat.",
      "audio": "https://santrikoding.com/storage/audio/001.mp3",
    }
  ];

  static final List<SurahEntities> listSurahEntities =
      surahJson.map((e) => SurahEntities.fromJson(e)).toList();

  static final SurahEntities surahEntities = listSurahEntities[0];
}
