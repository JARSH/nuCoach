import 'package:enum_to_string/enum_to_string.dart';
import 'package:nucoach/database/database_helpers.dart';
import 'package:nucoach/enums/exercise.dart';
import 'package:nucoach/models/rep.dart';

class Set {
  int id;
  Exercise exercise;
  int weight;
  int score;
  List<Rep> reps;

  static final columns = [
    columnId,
    columnSessionId,
    columnWeight,
    columnExercise,
    columnScore,
  ];

  Set(int id) {
    this.id = id;
    this.exercise = Exercise.Squat;
    this.reps = new List();
  }

  Set.fromMap(Map map) {
    this.id = map[columnId];
    this.exercise =
        EnumToString.fromString(Exercise.values, map[columnExercise]);
    this.weight = map[columnWeight];
    this.score = map[columnScore];
  }

  Map toMap() {
    Map map = {
      columnExercise: exercise,
      columnScore: score,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
