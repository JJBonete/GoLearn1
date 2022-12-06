import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    //path

    join(await getDatabasesPath(), 'flashcards.db'),
    onCreate: (db, version) {
      //run the table
      return db.execute(
        'CREATE TABLE topics(id INTEGER PRIMARY KEY, topicname TEXT)',
      );
    },
  );

//insert function
  Future<void> insertTopic(Topics topicsdb) async {
    final db = await database;

    await db.insert(
      'topicsdbs',
      topicsdb.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//retrieve data from the table
  Future<List<Topics>> topics() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('topicsdbs');

    return List.generate(maps.length, (i) {
      return Topics(
        id: maps[i]['id'],
        topicname: maps[i]['topicname'],
      );
    });
  }

  //update function
  Future<void> updateTopic(Topics topicsdb) async {
    final db = await database;

    await db.update('topicsdbs', topicsdb.toMap(),
        where: 'id = ?', whereArgs: [topicsdb.id]);
  }
}

class Topics {
  final int id;
  final String topicname;

  Topics({
    required this.id,
    required this.topicname,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topicname': topicname,
    };
  }

  String toString() {
    return 'Topics(id: $id, topicname: $topicname)';
  }
}
