import 'package:flutter/cupertino.dart';
import 'package:nucoach/rep.dart';

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