import 'package:flutter/material.dart';
import 'package:nucoach/models/rep.dart';
import 'package:nucoach/screens/breakdown/components/foot_pressure_map.dart';


class FPBreakdown extends StatelessWidget {
  Rep rep;

  FPBreakdown(rep) {
    this.rep = rep;
  }

  @override
  Widget build(BuildContext context) {
    return rep.fpmap;
  }
}
