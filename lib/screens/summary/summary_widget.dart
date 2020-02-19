import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:nucoach/models/session.dart';
import 'package:nucoach/models/set.dart';
import 'package:nucoach/screens/summary/components/set_widget.dart';

import 'package:nucoach/main.dart';
import 'package:nucoach/screens/home/home_widget.dart';

class SummaryWidget extends StatelessWidget {
  final Session session;

  SummaryWidget(this.session);

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat.yMd();
    return WillPopScope(
      onWillPop: () {
        Get.to(Home(cameras,0));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Session for ' + formatter.format(session.date)),
        ),
        body: ListView(
          children: createSetWidgets(this.session.sets),
        ),
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
