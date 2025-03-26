import 'package:flutter/cupertino.dart';
import 'package:quran/common/constants/route_constant.dart';
import 'package:quran/core/presentation/pages/detail_surah_page.dart';
import 'package:quran/core/presentation/pages/home_page.dart';

final class RouteFactoryUtil {
  static Widget getPageByName(String? name) {
    return switch (name) {
      RouteConstant.home => const HomePage(),
      RouteConstant.detailSurah => const DetailSurahPage(),
      _ => const SizedBox(),
    };
  }
}
