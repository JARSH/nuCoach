import 'package:nucoach/database/database_helpers.dart';
import 'package:nucoach/screens/breakdown/components/angles.dart';
import 'package:nucoach/screens/breakdown/components/foot_pressure_map.dart';
import 'dart:convert';

class Rep {
  int id;
  double score;
  Angles angles;
  FootPressureMap fpmap;

  Rep() {
    this.id = 1;
    this.score = 100;
    this.angles = new Angles(90, 50, 0, 70);
    //this.fpmap = new FootPressureMap(List.generate(4, (i) => List(4), growable: false));
  }

  static final columns = [
    columnId,
    columnSetId,
    columnScore,
    columnShk,
    columnHka,
    columnSA,
    columnKag,
    columnFpm,
  ];

  Rep.fromMap(Map map) {
    this.id = map[columnId];
    this.score = map[columnScore];
    this.angles = new Angles(map[columnShk].toDouble(), map[columnHka].toDouble(), map[columnSA].toDouble(), map[columnKag].toDouble());
    this.fpmap = new FootPressureMap(jsonDecode(map[columnFpm]));
  }

  List<List<int>> fromJson(Map<String, dynamic> json) =>
      List<List<int>>.from(json["matrix"].map((x) => List<int>.from(x.map((x) => x.toInteger()))));

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
