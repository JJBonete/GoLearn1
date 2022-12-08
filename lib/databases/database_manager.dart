import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/word.dart';
import 'dart:developer' as developer;

class DatabaseManager {
  //Singleton
  DatabaseManager._internal();

  static final _instance = DatabaseManager._internal();

  factory DatabaseManager() => _instance;

  //Database
  // I ONLY HAVE 1 TABLE FOR MY DATABASE
  final String _database = 'flashcards.db';
  final String _table = 'words';

  Future<Database> initDatabase() async {
    final dbPath = join(await getDatabasesPath(), _database);

    return await openDatabase(dbPath, onCreate: (db, version) {
      db.execute(
          'CREATE TABLE words (topic TEXT, theword TEXT PRIMARY KEY, type TEXT)');
    }, version: 1);
  }

  Future<String> insertWord({required Word word}) async {
    final db = await initDatabase();
    int id = await db.insert(_table, word.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return getWord(id: id);
  }

  Future<String> getWord({required int id}) async {
    final db = await initDatabase();
    String statement = 'SELECT * FROM words WHERE ID = ?';
    List<Map> result = await db.rawQuery(statement, [id]);

    return result.isEmpty ? '' : result[1].toString();
  }

  Future<List<Word>> selectWords({int? limit}) async {
    final db = await initDatabase();
    List<Map<String, dynamic>> maps =
        await db.query(_table, limit: limit, orderBy: 'RANDOM()');
    return List.generate(
        maps.length, (index) => Word.fromMap(map: maps[index]));
  }

  Future<void> removeWord({required Word word}) async {
    final db = await initDatabase();
    await db.delete(_table, where: 'theword = ?', whereArgs: [word.theword]);
  }

  Future<void> removeAllWords() async {
    final db = await initDatabase();
    await db.delete(_table);
  }

  Future<void> removeDatabase() async {
    final devicesPath = await getDatabasesPath();
    final path = join(devicesPath, _database);
    await deleteDatabase(path);
  }
}
