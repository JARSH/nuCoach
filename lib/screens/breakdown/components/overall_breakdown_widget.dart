import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nucoach/models/rep.dart';

class OverallBreakdown extends StatelessWidget {
  Rep rep;

  OverallBreakdown(rep) {
    this.rep = rep;
  }

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rep.score / 20,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: 50.0,
      //direction: Axis.vertical,
    );
  }
}
