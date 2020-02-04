import 'package:nucoach/exercise.dart';
import 'package:nucoach/rep.dart';

class Set {
  Set(int id) {
    this.id = id;
    this.exercise = Exercise.Squat;
    this.reps = new List();
    reps.add(Rep());
    reps.add(Rep());
    reps.add(Rep());
  }

  int id;
  Exercise exercise;
  int score;
  List<Rep> reps;
}
