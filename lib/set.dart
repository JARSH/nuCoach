import 'package:enum_to_string/enum_to_string.dart';
import 'package:nucoach/database_helpers.dart';
import 'package:nucoach/exercise.dart';
import 'package:nucoach/rep.dart';

class Set {
  int id;
  Exercise exercise;
  int score;
  List<Rep> reps;

  static final columns = [
    columnId,
    columnSessionId,
    columnExercise,
    columnScore,
  ];

  Set(int id) {
    this.id = id;
    this.exercise = Exercise.Squat;
    this.reps = new List();
    reps.add(Rep());
    reps.add(Rep());
    reps.add(Rep());
  }

  Set.fromMap(Map map) {
    this.id = map[columnId];
    this.exercise =
        EnumToString.fromString(Exercise.values, map[columnExercise]);
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
