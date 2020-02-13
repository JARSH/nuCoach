import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nucoach/models/rep.dart';
import 'package:nucoach/models/session.dart';
import 'package:nucoach/models/set.dart';
import 'package:nucoach/screens/summary/summary_widget.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../database/database_helpers.dart';

class CalendarWidget extends StatefulWidget {
  CalendarWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarController: _calendarController,
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      onDaySelected: _onDaySelected,
    );
  }

  void _onDaySelected(DateTime day, List events) async {
    print('CALLBACK: _onDaySelected' + day.toString());
    Session session = await _queryWithDate(day);
    if (session != null) {
      Get.to(SummaryWidget(session));
    } else {
      Get.snackbar(
        "Notice",
        "No data recorded for this date",
        margin: EdgeInsets.only(top: 75),
      );
    }
  }

  Future<Session> _queryWithDate(DateTime date) async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    // final session = await dbHelper.fetchSessionByDate(date.toIso8601String());
    final sessionResult = await dbHelper.queryAllSessionRows();
    if (sessionResult != null && sessionResult.length != 0) {
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
    } else {
      return null;
    }
  }
}
