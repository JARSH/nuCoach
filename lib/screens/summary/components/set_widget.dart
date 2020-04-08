import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nucoach/models/set.dart';
import 'package:nucoach/screens/breakdown/breakdown_widget.dart';

class SetWidget extends StatelessWidget {
  final Set set;
  final int listNum;

  SetWidget(this.set, this.listNum);

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Set " + (listNum + 1).toString() + " Weight: " + set.weight.toString(),
          style: Theme.of(context).textTheme.body2,
        ),
      ),
      expanded: Column(
        children: <Widget>[
          for (int i = 0; i < set.reps.length; i++)
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: FlatButton(
                child: Text(
                  "Rep " +
                      (i + 1).toString() +
                      "                     Score: " +
                      set.reps[i].score.toString(),
                ),
                onPressed: () {
                  Get.to(Breakdown(set.reps[i]));
                },
              ),
            ),
        ],
      ),
    );
  }
}
