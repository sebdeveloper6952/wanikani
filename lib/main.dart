import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:wanikani/home_view.dart';
import 'package:wanikani/kanji/kanji_bloc.dart';
import 'package:wanikani/wanikani/api.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final log = Logger("main");

  final api = WanikaniApi();
  final fetchUserResult = await api.fetchUserInfo();
  fetchUserResult.when(
    (success) => {},
    (error) => {log.severe("can't get user: $error")},
  );

  final kanjiBloc = KanjiBloc();

  runApp(MyApp(
    kanjiBloc: kanjiBloc,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required KanjiBloc kanjiBloc,
  }) : _kanjiBloc = kanjiBloc;

  final KanjiBloc _kanjiBloc;

  ThemeData _buildTheme(Brightness brightness) {
    ThemeData baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: brightness,
      ),
      brightness: brightness,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.firaCodeTextTheme(baseTheme.textTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<KanjiBloc>(
          create: (_) => KanjiBloc(),
        ),
      ],
      child: MaterialApp(
        theme: _buildTheme(
          Brightness.dark,
        ),
        home: const HomeView(),
      ),
    );
  }
}
