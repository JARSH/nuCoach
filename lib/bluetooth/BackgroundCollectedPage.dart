import 'package:flutter/material.dart';
import 'package:nucoach/screens/breakdown/components/foot_pressure_map.dart';

import './BackgroundCollectingTask.dart';

class BackgroundCollectedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BackgroundCollectingTask task =
        BackgroundCollectingTask.of(context, rebuildOnChange: true);

    // Arguments shift is needed for timestamps as milliseconds in double could lose precision.
    final int argumentsShift =
        task.samples.first.timestamp.millisecondsSinceEpoch;

    final Duration showDuration =
        Duration(hours: 2); // @TODO . show duration should be configurable.
    final Iterable<DataSample> lastSamples = task.getLastOf(showDuration);

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
      body: FootPressureMap(task.matrix),
    );
  }
}
