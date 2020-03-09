import 'package:flutter/material.dart';
import 'package:nucoach/models/rep.dart';
import 'package:nucoach/screens/breakdown/components/angles.dart';
import 'dart:math' as math;

class CVBreakdown extends StatelessWidget {
  Rep rep;

  CVBreakdown(rep) {
    this.rep = rep;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text("SHK: " + (rep.angles.shk*180/math.pi).toString() + "\nHKA: " + (rep.angles.hka*180/math.pi).toString()),
        Container(
      // width: 100,
      // height: 100,
          child: Angles(this.rep.angles.shk, this.rep.angles.hka)//Text("SHK: " + rep.angles.shk.toString() + "\nHKA: " + rep.angles.hka.toString()),
        ),
      ]);

    //return rep.angles;
  }
}
