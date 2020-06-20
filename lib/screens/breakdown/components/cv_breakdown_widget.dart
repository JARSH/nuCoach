import 'package:flutter/material.dart';
import 'package:nucoach/models/rep.dart';
import 'dart:math' as math;

class CVBreakdown extends StatelessWidget {
  Rep rep;

  CVBreakdown(rep) {
    this.rep = rep;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Shoulder-Hip-Knee Angle: " + (rep.angles.shk*180/math.pi).round().toString() +'\u00B0'
           + "\nHip-Knee-Ankle Angle: " + (rep.angles.hka*180/math.pi).round().toString() +'\u00B0'
           + "\nWeight to center of balance distance: " + rep.angles.sa_dist.toString()),
        Container(
      // width: 100,
      // height: 100,
          child: this.rep.angles
        ),
      ]);

  }
}
