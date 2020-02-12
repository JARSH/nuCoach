import 'package:flutter/material.dart';
import 'package:nucoach/models/rep.dart';

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
