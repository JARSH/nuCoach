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
    var tip;
    if (rep.angles.sa_dist < -.10)
      tip = "Your center of balance is behind your feet, bring the weight forward a bit.";
    else if (rep.angles.sa_dist > .10)
      tip = "Your center of balance is in front of your feet, bring your shoulders back a bit.";
    else
      tip = "You're doing great, keep it up!";
    return Column (
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RatingBarIndicator(
          rating: rep.score*1.0,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: 50.0,
          //direction: Axis.vertical,
        ),
        Text("Tip: " + tip),
      ]
    );
  }
}
