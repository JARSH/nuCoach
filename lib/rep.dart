import 'package:nucoach/angles.dart';
import 'package:nucoach/database_helpers.dart';
import 'package:nucoach/foot_pressure_map.dart';

class Rep {
  int id;
  int score;
  Angles angles;
  FootPressureMap fpmap;

  Rep() {
    this.id = 1;
    this.score = 100;
    this.angles = new Angles();
    this.angles.shk = 90;
    this.angles.hka = 50;
    this.fpmap = new FootPressureMap();
  }

  static final columns = [
    columnId,
    columnSetId,
    columnScore,
    columnShk,
    columnHka,
    columnFmp,
  ];

  Rep.fromMap(Map map) {
    this.id = map[columnId];
    this.score = map[columnScore];
  }

  Map toMap() {
    Map map = {
      columnScore: score,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
