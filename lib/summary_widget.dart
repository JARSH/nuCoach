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
        children: <Widget>[
          SetWidget(Set(1)),
          SetWidget(Set(2)),
          SetWidget(Set(3)),
        ],
      ),
    );
  }
}
