import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class RepoLocalDatasource {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'repos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE repos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            path TEXT UNIQUE,
            lastAction TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertRepo({required String name, required String path, required String lastAction}) async {
    final db = await database;
    await db.insert(
      'repos',
      {'name': name, 'path': path, 'lastAction': lastAction},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getRepos() async {
    final db = await database;
    return db.query('repos', orderBy: 'id DESC');
  }
}
