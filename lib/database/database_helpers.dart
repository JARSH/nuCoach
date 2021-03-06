import 'dart:io';

import 'package:nucoach/models/session.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nucoach/models/set.dart';
import 'package:nucoach/models/rep.dart';

final String tableSessions = 'sessions';
final String tableSets = 'sets';
final String tableReps = 'reps';
final String columnId = '_id';
final String columnSessionId = 'session_id';
final String columnSetId = 'set_id';
final String columnDate = 'date';
final String columnExercise = 'exercise';
final String columnWeight = 'weight';
final String columnScore = 'score';
final String columnShk = 'shk';
final String columnHka = 'hka';
final String columnFpm = 'fpm';
final String columnSA = 'sa_dist';
final String columnKag = 'kag';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableSessions (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnDate TEXT
      )
      ''');
    await db.execute('''
          CREATE TABLE $tableSets (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnSessionId INTEGER,
            $columnExercise TEXT,
            $columnWeight INTEGER,
            $columnScore DOUBLE
      )
      ''');
    await db.execute('''
          CREATE TABLE $tableReps (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnSetId INTEGER,
            $columnScore DOUBLE,
            $columnShk INTEGER,
            $columnHka INTEGER,
            $columnSA INTEGER,
            $columnKag INTEGER,
            $columnFpm TEXT
      )
      ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertSession(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableSessions, row);
  }

  Future<int> insertSet(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableSets, row);
  }

  Future<int> insertRep(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableReps, row);
  }

  // All the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllSessionRows() async {
    Database db = await instance.database;
    return await db.query(tableSessions);
  }

  Future<Map<String, dynamic>> fetchSessionByDate(String date) async {
    Database db = await instance.database;
    List<Map> results = await db.query(
      tableSessions,
      columns: Session.columns,
      where: "$columnDate = ?",
      whereArgs: [date],
    );
    if (results.isEmpty) {
      return null;
    }
    return results[0];
  }

  Future<List<Map<String, dynamic>>> queryAllSetRows() async {
    Database db = await instance.database;
    return await db.query(tableSets);
  }

  Future<List<Set>> fetchSetsWithSessionId(int sessionId) async {
    List<Map> results = await _database.query(
        tableSets,
        columns: Set.columns,
        where: "$columnSessionId = ?",
        whereArgs: [sessionId]
    );
    List<Set> sets = new List();
    results.forEach((result) {
      Set set = Set.fromMap(result);
      sets.add(set);
    });
    return sets;
  }

  Future<List<Map<String, dynamic>>> queryAllRepRows() async {
    Database db = await instance.database;
    return await db.query(tableReps);
  }

  Future<List<Rep>> fetchRepswithSetId(int setID) async {
    List<Map> results = await _database.query(
      tableReps,
      columns: Rep.columns,
      where: "$columnSetId = ?",
      whereArgs: [setID]
    );
    List<Rep> reps = new List();
    results.forEach((result) {
      Rep rep = Rep.fromMap(result);
      reps.add(rep);
    });
    return reps;

  }
}
