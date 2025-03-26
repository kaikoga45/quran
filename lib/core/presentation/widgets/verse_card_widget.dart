import 'package:flutter/cupertino.dart';
import 'package:quran/common/constants/color_constant.dart';
import 'package:quran/common/extensions/list_extension.dart';
import 'package:quran/core/domain/entities/detail_surah_entities.dart';

class VerseCard extends StatelessWidget {
  final int index;
  final Verse verse;

  const VerseCard({
    super.key,
    required this.index,
    required this.verse,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: 15,
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorConstant.valentineRed,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                Text((index + 1).toString()),
              ],
            ),
          ),
          Text(
            verse.arabic,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontSize: 23),
          ),
          Text(
            verse.translation,
            style: const TextStyle(fontSize: 14),
          ),
        ].spacing(
          height: 15,
          hasSpaceFirstItem: false,
          hasSpaceLastItem: false,
        ),
      ),
    );
  }
}
