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
      width: 0.0,
      height: 0.0,
    );
    //return rep.angles;
  }
}
