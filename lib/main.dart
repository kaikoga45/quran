import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/common/constants/color_constant.dart';
import 'package:quran/common/constants/route_constant.dart';
import 'package:quran/common/helpers/locator/repository_locator_helper.dart';
import 'package:quran/common/helpers/locator/service_locator_helper.dart';
import 'package:quran/common/utils/route_factory_util.dart';
import 'package:quran/core/presentation/pages/home_page.dart';

void main() {
  setupLocator();
  runApp(const QuranApp());
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: repositoriesProvider,
      child: CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'Quran',
        theme: const CupertinoThemeData(
          brightness: Brightness.dark,
          primaryColor: ColorConstant.valentineRed,
        ),
        initialRoute: RouteConstant.home,
        onGenerateRoute: (settings) {
          return CupertinoPageRoute(
            builder: (_) => RouteFactoryUtil.getPageByName(settings.name),
            settings: settings,
          );
        },
        home: const HomePage(),
      ),
    );
  }
}
