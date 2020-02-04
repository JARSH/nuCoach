import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nucoach/session.dart';
import 'package:nucoach/summary_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarController: CalendarController(),
      onDaySelected: _onDaySelected,
    );
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected' + day.toString());
    Get.to(SummaryWidget(Session(day)));
  }
}
