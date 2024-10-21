import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanikani/db/db.dart';
import 'package:wanikani/home_view.dart';
import 'package:wanikani/kanji/kanji_bloc.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  // we don't need the status bar
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  );

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final storage = await SharedPreferences.getInstance();
  final dbPath = "${await getDatabasesPath()}/wanikani.db";
  final db = await openDb(dbPath);

  runApp(
    MyApp(
      db: db,
      storage: storage,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required Database db,
    required SharedPreferences storage,
  })  : _db = db,
        _storage = storage;

  final Database _db;
  final SharedPreferences _storage;

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<KanjiBloc>(
          create: (_) => KanjiBloc(
            widget._db,
            widget._storage,
          ),
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
