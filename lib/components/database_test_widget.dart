import 'package:flutter/material.dart';
import 'package:nucoach/database/database_helpers.dart';

import '../enums/exercise.dart';

class DatabaseTestWidget extends StatelessWidget {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(
                'insert session',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _insertSession();
              },
            ),
            RaisedButton(
              child: Text(
                'query sessions',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _querySessions();
              },
            ),
            RaisedButton(
              child: Text(
                'insert set',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _insertSet();
              },
            ),
            RaisedButton(
              child: Text(
                'query sets',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _querySets();
              },
            ),
            RaisedButton(
              child: Text(
                'insert rep',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _insertRep();
              },
            ),
            RaisedButton(
              child: Text(
                'query reps',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _queryReps();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Button onPressed methods

  void _insertSession() async {
    // row to insert
    Map<String, dynamic> row = {columnDate: DateTime.now().toIso8601String()};
    final id = await dbHelper.insertSession(row);
    print('inserted row id: $id');
  }

  void _insertSet() async {
    Map<String, dynamic> row = {
      columnSessionId: 1,
      columnExercise: Exercise.Squat.toString(),
      columnScore: 95,
    };
    final id = await dbHelper.insertSet(row);
    print('inserted row id: $id');
  }

  void _insertRep() async {
    Map<String, dynamic> row = {
      columnScore: 57,
    };
    final id = await dbHelper.insertRep(row);
    print('inserted row id: $id');
  }

  void _querySessions() async {
    final allRows = await dbHelper.queryAllSessionRows();
    print('query all sessions:');
    allRows.forEach((row) => print(row));
  }

  void _querySets() async {
    final allRows = await dbHelper.queryAllSetRows();
    print('query all sets:');
    allRows.forEach((row) => print(row));
  }

  void _queryReps() async {
    final allRows = await dbHelper.queryAllRepRows();
    print('query all reps:');
    allRows.forEach((row) => print(row));
  }
}
