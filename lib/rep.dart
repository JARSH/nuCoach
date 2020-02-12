import 'package:nucoach/angles.dart';
import 'package:nucoach/foot_pressure_map.dart';

class Rep {
  Rep() {
    this.id = 1;
    this.score = 100;
    this.angles = new Angles();
    this.angles.shk = 90;
    this.angles.hka = 50;
    this.fpmap = new FootPressureMap();
  }

  int id;
  int score;
  Angles angles;
  FootPressureMap fpmap;
}
