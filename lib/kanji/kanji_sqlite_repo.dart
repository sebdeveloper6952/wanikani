import 'dart:async';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wanikani/wanikani/api.dart';
import 'package:wanikani/wanikani/models.dart';

final _subjectsTable = "subjects";

class KanjiSqliteRepo {
  final WanikaniApi api;
  final Database db;
  final Map<int, Subject> _subjects = {};
  final _log = Logger("KanjiSqliteRepo");

  KanjiSqliteRepo({required this.api, required this.db});

  Future<void> init() async {
    final fetchUserResult = await api.fetchUserInfo();
    if (fetchUserResult.isError()) {
      _log.severe(fetchUserResult.tryGetError());
      await _loadSubjectsFromDB();
      return;
    }

    final user = fetchUserResult.tryGetSuccess();
    if (user == null) {
      _log.severe(fetchUserResult.tryGetError());
      await _loadSubjectsFromDB();
      return;
    }

    final subjectsResult = await api.fetchSubjectsForLevel(user.level);
    final subjects = subjectsResult.tryGetSuccess();
    if (subjects == null) {
      _log.severe(subjectsResult.tryGetError());
      await _loadSubjectsFromDB();
      return;
    }

    await _updateSubectsDB(subjects);
    await _loadSubjectsFromDB();
  }

  Future<void> _updateSubectsDB(List<Subject> subjects) async {
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var sub in subjects) {
        batch.insert(
          _subjectsTable,
          sub.toDbMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit();
    });
  }

  Future<void> _loadSubjectsFromDB() async {
    final rows = await db.query(
      _subjectsTable,
      columns: [],
    );

    for (var row in rows) {
      final subject = Subject.fromDbMap(row);
      _subjects[subject.id] = subject;
    }
  }

  Future<Subject?> getSubjectById(int id) async {
    return _subjects[id];
  }

  Future<Subject?> getRandomSubject() async {
    final randomIndex = _subjects.keys.elementAt(
      Random().nextInt(
        _subjects.length,
      ),
    );

    return _subjects[randomIndex];
  }
}
