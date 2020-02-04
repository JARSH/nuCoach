import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:nucoach/set.dart';

class SetWidget extends StatelessWidget {
  final Set set;

  SetWidget(this.set);

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Set " + set.id.toString(),
            style: Theme.of(context).textTheme.body2,
          ),
      ),
      expanded: Column(
        children: <Widget>[
          for (int i = 0; i < set.reps.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 20),
              child: Text(
                "Rep " + (i + 1).toString() + "                      " +
                    set.reps[i].score.toString(),
              ),
            ),
        ],
      ),
    );
  }
}
