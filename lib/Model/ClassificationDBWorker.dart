import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'Classification.dart';

class ClassificationDBWorker {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'picture_name';
  static const String CLASS = 'picture_class';
  static const String TABLE = 'ClassificationsTable';
  static const String DB_NAME = 'classifications.db';

  Future<Database> get db async {
    if (null != _db) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $TABLE ($ID INTEGER, $NAME TEXT, $CLASS TEXT)");
  }

  Future<Classification> save(Classification pic) async {
    var dbClient = await db;
    pic.id = await dbClient.insert(TABLE, pic.toMap());
    return pic;
  }

  Future<Classification> deleteClassification(Classification pic) async {
    var dbClient = await db;
    pic.id = await dbClient.delete("ClassificationsTable", where : "picture_name = ?", whereArgs : [pic.picture_name]);
    return pic;
  }

  Future<List<Classification>> getClassifications() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME, CLASS]);
    List<Classification> allpics = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        allpics.add(Classification.fromMap(maps[i]));
      }
    }
    return allpics;
  }
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}