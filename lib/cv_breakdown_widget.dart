import 'package:flutter/cupertino.dart';
import 'package:nucoach/rep.dart';

class CVBreakdown extends StatelessWidget {
  Rep rep;

  CVBreakdown(rep) {
    this.rep = rep;
  }

  @override
  Widget build(BuildContext context) {
    return rep.angles;
  }
}