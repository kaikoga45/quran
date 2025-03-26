import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/common/constants/route_constant.dart';
import 'package:quran/core/domain/entities/surah_entities.dart';
import 'package:quran/core/domain/repositories/surah_repositories.dart';
import 'package:quran/core/presentation/blocs/surah/surah_bloc.dart';
import 'package:quran/core/presentation/widgets/loading_widget.dart';
import 'package:quran/core/presentation/widgets/surah_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final surahRepositories =
            RepositoryProvider.of<SurahRepositories>(context);
        return SurahBloc(surahRepositories)..add(GetSurah());
      },
      child: BlocBuilder<SurahBloc, SurahState>(
        builder: (context, state) {
          return switch (state) {
            SurahLoading _ => const LoadingWidget(),
            SurahLoaded surahLoaded => LoadedHomePage(surahLoaded.listSurah),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}

class LoadedHomePage extends StatefulWidget {
  final List<SurahEntities> listSurah;

  const LoadedHomePage(
    this.listSurah, {
    super.key,
  });

  @override
  State<LoadedHomePage> createState() => _LoadedHomePageState();
}

class _LoadedHomePageState extends State<LoadedHomePage> {
  late List<SurahEntities> searchSurah;

  @override
  void initState() {
    searchSurah = widget.listSurah;
    super.initState();
  }

  @override
  Widget build(context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Quran'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CupertinoSearchTextField(
                placeholder: 'Surah',
                onSubmitted: (value) {
                  setState(() {
                    if (value.isEmpty) searchSurah = widget.listSurah;
                    searchSurah = widget.listSurah
                        .where(
                          (e) => e.latinName
                              .toLowerCase()
                              .contains(value.toLowerCase()),
                        )
                        .toList();
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListSurahWidget(
                  listSurah: searchSurah,
                  onTap: (surahNumber) {
                    Navigator.pushNamed(
                      context,
                      RouteConstant.detailSurah,
                      arguments: surahNumber,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
