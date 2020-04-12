import 'package:flutter/material.dart';
import 'package:nucoach/bluetooth/FootPressureCollector.dart';
import 'package:nucoach/screens/breakdown/components/foot_pressure_map.dart';

import './BackgroundCollectingTask.dart';

class FootPressureCollectedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FootPressureCollector task =
    FootPressureCollector.of(context, rebuildOnChange: false);

    final List<List<dynamic>> result = task.getMatrix();

    return Scaffold(
      appBar: AppBar(
        title: Text('Collected data'),
        actions: <Widget>[
          // Progress circle
          (task.inProgress
              ? FittedBox(
              child: Container(
                  margin: new EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white))))
              : Container(/* Dummy */)),
          // Start/stop buttons
          (task.inProgress
              ? IconButton(icon: Icon(Icons.pause), onPressed: task.pause)
              : IconButton(
              icon: Icon(Icons.play_arrow), onPressed: task.reasume)),
        ],
      ),
      body: FootPressureMap(result),
    );
  }
}
