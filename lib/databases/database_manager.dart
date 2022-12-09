import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:golearnv2/databases/database_manager.dart';
import '../models/word.dart';
import 'package:golearnv2/data/words.dart';
import 'dart:developer' as developer;

class DatabaseManager {
  //Singleton
  DatabaseManager._internal();

  static final _instance = DatabaseManager._internal();

  factory DatabaseManager() => _instance;

  //Database
  // I ONLY HAVE 1 TABLE FOR MY DATABASE
  final String _database = 'flashcards.db',
      _table = 'words',
      _column1 = 'topic',
      _column2 = 'theword',
      _column3 = 'type';
  final String _reviewTable = 'reviews';

  Future<Database> initDatabase() async {
    final dbPath = join(await getDatabasesPath(), _database);

    return await openDatabase(dbPath, onCreate: (db, version) {
      developer.log('initializing database');
      db.execute(
          'CREATE TABLE words (topic TEXT, theword TEXT PRIMARY KEY, type TEXT)');
      words.forEach((word) => {
            db.insert(_table, word.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace)
          });
    }, version: 1);
  }

  Future<List<Word>> filterTopics({required String topic}) async {
    final db = await initDatabase();

    if (topic == 'All') {
      return await selectWords();
    }

    List<Map<String, dynamic>> results =
        await db.query(_table, where: '$_column1=?', whereArgs: [topic]);
    return List.generate(
        results.length, (index) => Word.fromMap(map: results[index]));
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

  Future<List<String>> getTopics() async {
    final db = await initDatabase();
    List<Map<String, Object?>> results =
        await db.query(_table, distinct: true, columns: ['topic']);

    List<String> data = [];

    results.forEach((record) => data.add(record['topic'] as String));
    data.sort();
    data.insertAll(0, ['Random 5', 'Random 20', 'Random 50', 'Test All']);

    return data;
  }

  Future<void> getWordsOfTopic({required String topic}) async {
    final db = await initDatabase();
    List<Map<String, dynamic>> results =
        await db.query(_table, where: "topic=?", whereArgs: [topic]);
    developer.log("Results from Topics Database $results");
    // temporarily delete the database
    await removeDatabase();
    return;
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
    developer.log("removing database $path");
    await deleteDatabase(path);
  }
}
