import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nucoach/session.dart';
import 'package:nucoach/set.dart';
import 'package:nucoach/set_widget.dart';

class SummaryWidget extends StatelessWidget {
  final Session session;

  SummaryWidget(this.session);

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat.yMd();
    return Scaffold(
      appBar: AppBar(
        title: Text('Session for ' + formatter.format(session.date)),
      ),
      body: ListView(
        children: createSetWidgets(this.session.sets),
      ),
    );
  }

  List<Widget> createSetWidgets(List<Set> sets) {
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < sets.length; i++) {
      list.add(new SetWidget(sets[i]));
    }
    return list;
  }
}
