import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nucoach/rep.dart';
import 'package:nucoach/session.dart';
import 'package:nucoach/set.dart';
import 'package:nucoach/summary_widget.dart';
import 'package:table_calendar/table_calendar.dart';

import 'database_helpers.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarController: CalendarController(),
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      onDaySelected: _onDaySelected,
    );
  }

  void _onDaySelected(DateTime day, List events) async {
    print('CALLBACK: _onDaySelected' + day.toString());
    Get.to(SummaryWidget(await _queryWithDate(day)));
  }

  Future<Session> _queryWithDate(DateTime date) async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    // final session = await dbHelper.fetchSessionByDate(date.toIso8601String());
    final sessionResult = await dbHelper.queryAllSessionRows();
    Session session = Session.fromMap(sessionResult[0]);
    session.sets = new List<Set>();
    final setsResult = await dbHelper.queryAllSetRows();
    for (var result in setsResult) {
      Set set = Set.fromMap(result);
      set.reps = new List<Rep>();
      final repsResult = await dbHelper.queryAllRepRows();
      for (var result in repsResult) {
        set.reps.add(Rep.fromMap(result));
      }
      session.sets.add(set);
    }
    return session;
  }
}
