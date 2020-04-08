import 'package:flutter/material.dart';
import 'dart:math' as math;

class Angles extends StatelessWidget {
  static double size = 500;    //size of CustomPaint widget
  double shk;
  double hka;
  double sa_dist;   //horizontal distance from shoulder to ankle
  double kag;     //angle of ankle
  Offset head;
  Offset foot;
  Offset shoulderOffset;
  Offset ankleOffset;
  Offset hipOffset;     //  = new Offset(0.6*size, 0.6*size);  //(hip on right) no longer constant
  final double backLength = 0.375*size;
  final double calfLength = 0.3*size;
  final double thighLength = 0.3*size;
  final Offset kneeOffset = new Offset(0.3*size, 0.75*size); //(knee on left)


  Angles(double shk, double hka, double sa_dist, double kag) {
    this.shk = shk;
    this.hka = hka;
    this.sa_dist = sa_dist;
    this.kag = kag;
  }

  @override
  Widget build(BuildContext context) {
    _calculatePoints();
    return CustomPaint( //                       <-- CustomPaint widget
        size: Size(size, size), //size might be different
        painter: MyPainter(shoulderOffset, hipOffset, kneeOffset, ankleOffset),
      );
  }

  _calculatePoints() {
    double hipX, hipY, shoulderX, shoulderY, ankleX, ankleY;
    ankleX = kneeOffset.dx + math.cos(kag)*calfLength;
    ankleY = kneeOffset.dy + math.sin(kag)*calfLength;
    ankleOffset = new Offset(ankleX, ankleY);

    hipX = kneeOffset.dx + thighLength*math.sin(hka)*math.cos(math.pi/2-kag) + thighLength*math.cos(hka)*math.sin(math.pi/2-kag);
    hipY = kneeOffset.dy - thighLength*math.sin(hka)*math.sin(math.pi/2-kag) + thighLength*math.cos(hka)*math.cos(math.pi/2-kag);
    hipOffset = new Offset(hipX, hipY);

    double rot = hka-kag;
    shoulderX = hipOffset.dx - (backLength*math.cos(shk)*math.cos(rot) + backLength*math.sin(shk)*math.sin(rot));
    shoulderY = hipOffset.dy - (-math.cos(shk)*backLength*math.sin(rot) + backLength*math.sin(shk)*math.cos(rot));
    shoulderOffset = new Offset(shoulderX, shoulderY);
  }

  
}

class MyPainter extends CustomPainter { //         <-- CustomPainter class
  final shoulderOffset;
  final hipOffset;
  final kneeOffset;
  final ankleOffset;

  MyPainter(this.shoulderOffset, this.hipOffset, this.kneeOffset, this.ankleOffset);

  // MyPainter(Offset s, Offset h, Offset k, Offset a) {

  // }

  @override
  void paint(Canvas canvas, Size size) {
    //                                             <-- Insert your painting code here.
    final paint = Paint()
    ..color = Colors.lightBlue
    ..strokeWidth = 5;
    canvas.drawLine(shoulderOffset, hipOffset, paint);
    canvas.drawLine(hipOffset, kneeOffset, paint);
    canvas.drawLine(kneeOffset, ankleOffset, paint);
    canvas.drawCircle(shoulderOffset, 40, paint);
    Rect rect = new Offset(ankleOffset.dx-30,ankleOffset.dy) & const Size(50,30);
    canvas.drawRect(rect,paint);
    //canvas.drawLine(new Offset(0,0), new Offset(10,10), paint);k    //i.e. (0,0) is top left!!
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}


