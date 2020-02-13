import 'package:flutter/material.dart';
import 'package:nucoach/models/rep.dart';

class CVBreakdown extends StatelessWidget {
  Rep rep;

  CVBreakdown(rep) {
    this.rep = rep;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Text(rep.angles.shk.toString() + rep.angles.hka.toString()),
    );
    //return rep.angles;
  }
}
