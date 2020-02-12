import 'package:nucoach/database/database_helpers.dart';
import 'package:nucoach/models/set.dart';

class Session {
  int id;
  DateTime date;
  List<Set> sets;

  static final columns = [columnId, columnDate];

  Session(DateTime date) {
    this.date = date;
  }

  Session.fromMap(Map<String, dynamic> map) {
    this.id = map[columnId];
    this.date = DateTime.parse(map[columnDate]);
  }

  Map toMap() {
    Map map = {
      columnDate: date,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
