import 'package:flutter/cupertino.dart';
import 'package:quran/core/domain/entities/surah_entities.dart';

class ListSurahWidget extends StatelessWidget {
  final List<SurahEntities> listSurah;
  final Function(int surahNumber) onTap;

  const ListSurahWidget({
    super.key,
    required this.listSurah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listSurah.length,
      itemBuilder: (context, index) {
        final SurahEntities surah = listSurah[index];
        return CupertinoListTile(
          padding: const EdgeInsets.only(left: 0),
          leading: Text('${surah.number}'),
          title: Text(
            '${surah.latinName} ${surah.name}',
          ),
          subtitle:
              Text('${surah.numberOfVerses} ayah, ${surah.placeOfRevelation}'),
          onTap: () => onTap(surah.number),
        );
      },
    );
  }
}
