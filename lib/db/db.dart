import 'package:sqflite/sqflite.dart';

Future<Database> openDb(String path) async {
  return await openDatabase(
    path,
    version: 1,
    onConfigure: (Database db) async {
      await db.execute("PRAGMA foreign_keys = ON");
    },
    onCreate: (db, version) async {
      var batch = db.batch();
      _createTableSubjects(batch);
      await batch.commit();
    },
    onDowngrade: onDatabaseDowngradeDelete,
  );
}

void _createTableSubjects(Batch batch) {
  batch.execute("DROP TABLE IF EXISTS subjects");
  batch.execute(
    '''
    CREATE TABLE subjects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        object TEXT,
        url TEXT,
        data BLOB
    )''',
  );
}
