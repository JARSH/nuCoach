import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nucoach/database/database_helpers.dart';
import 'package:nucoach/main.dart';
import 'package:nucoach/models/session.dart';
import 'package:nucoach/models/set.dart';
import 'package:nucoach/screens/home/home_widget.dart';
import 'package:nucoach/screens/summary/components/set_widget.dart';

class SummaryWidget extends StatefulWidget {
  final Session session;

  SummaryWidget(this.session);

  @override
  State<StatefulWidget> createState() {
    return new SummaryWidgetState();
  }
}

class SummaryWidgetState extends State<SummaryWidget> {
  Future sessionFuture;

  @override
  void initState() {
    super.initState();
    sessionFuture = _populateSession();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat.yMd();
    return WillPopScope(
      onWillPop: () {
        Get.to(Home(cameras, 0));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Session for ' + formatter.format(widget.session.date)),
        ),
        body: FutureBuilder(
          future: sessionFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('none');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Text('Retrieving data...');
              case ConnectionState.done:
                return ListView(
                  children: createSetWidgets(widget.session.sets),
                );
              default:
                return Text('default');
            }

          }

        )
      ),
    );
  }

  createSetWidgets(List<Set> sets) {
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < sets.length; i++) {
      list.add(new SetWidget(sets[i], i));
    }
    return list;
  }

  _populateSession() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    widget.session.sets = new List<Set>();
    final setsResult = await dbHelper.fetchSetsWithSessionId(widget.session.id);
    for (var set in setsResult) {
      set.reps = await dbHelper.fetchRepswithSetId(set.id);
      widget.session.sets.add(set);
    }
  }
}
