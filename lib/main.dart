import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:wanikani/db/db.dart';
import 'package:wanikani/home_view.dart';
import 'package:wanikani/kanji/kanji_bloc.dart';
import 'package:wanikani/kanji/kanji_sqlite_repo.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wanikani/wanikani/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // we don't need the status bar
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  );

  await dotenv.load(fileName: ".env");

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final api = WanikaniApi(
    dotenv.env["WANIKANI_TOKEN"]!,
  );

  final dbPath = "${await getDatabasesPath()}/wanikani.db";
  final db = await openDb(dbPath);

  final repo = KanjiSqliteRepo(
    api: api,
    db: db,
  );

  final kanjiBloc = KanjiBloc(
    repo: repo,
  );

  runApp(
    MyApp(
      kanjiBloc: kanjiBloc,
      repo: repo,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required KanjiBloc kanjiBloc,
    required KanjiSqliteRepo repo,
  })  : _kanjiBloc = kanjiBloc,
        _repo = repo;

  final KanjiBloc _kanjiBloc;
  final KanjiSqliteRepo _repo;

  @override
  createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  ThemeData _buildTheme(Brightness brightness) {
    ThemeData baseTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.montserratTextTheme(baseTheme.textTheme),
    );
  }

  Future<void> _init() async {
    await widget._repo.init();
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<KanjiBloc>(
          create: (_) => widget._kanjiBloc,
        ),
      ],
      child: MaterialApp(
        theme: _buildTheme(
          Brightness.dark,
        ),
        home: const HomeView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
