import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:quick_notes/src/models/Note.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  var database;
  static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();

  factory DatabaseHelper() => _databaseHelper;

  DatabaseHelper._internal() {
    this.database = loadDatabase();
  }

  Future<Database> loadDatabase() async {
    var dbInstance;
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "notes_database.db");

    var exists = await databaseExists(path);

    if (!exists) {

      print("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e.toString());
      }

      ByteData data = await rootBundle.load(join("assets", "notes_database.db"));

      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);

    } else {

      print("Opening existing database");

    }

    dbInstance = await openDatabase(path, readOnly: false);

    return dbInstance;
  }

  Future insertNote(Note note) async {
    final Database db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM notes");

    int id = table.first["id"];

    var res = await db.rawInsert(
        "INSERT Into notes (id,title,body)"
            " VALUES (?,?,?)",
        [id, note.title, note.body]);
    return res;
  }

  Future<List<Note>> getAllNotes() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM notes");

    return List.generate(maps.length, (index){
      return Note.fromMap(maps[index]);
    });
  }

  Future updateNote(Note note) async {
    final Database db = await database;
    var res = await db.rawInsert(
        "REPLACE INTO notes (id,title,body)"
            " VALUES (?,?,?)",
        [note.id, note.title, note.body]);

    return res;
  }

  Future deleteNote(Note note) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.execute("DELETE FROM notes WHERE id = '${note.id}'");
      print("Successfully deleted: ${note.id}");
    });
  }


}
