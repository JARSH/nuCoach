import 'package:flutter/material.dart';
import 'dart:math' as math;

class Angles extends StatelessWidget {
  static double size = 500;    //size of CustomPaint widget
  double shk;
  double hka;
  Offset head;
  Offset foot;
  Offset shoulderOffset;
  Offset ankleOffset;
  final double backLength = 0.4*size;
  final double calfLength = 0.3*size;
  final Offset hipOffset = new Offset(0.6*size, 0.6*size);  //(hip on right)
  final Offset kneeOffset = new Offset(0.3*size, 0.6*size); //(knee on left)


  Angles(double shk, double hka) {
    this.shk = shk;
    this.hka = hka;
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
    double shoulderX, shoulderY, ankleX, ankleY;
    shoulderX = hipOffset.dx - math.cos(shk)*backLength;
    shoulderY = hipOffset.dy - math.sin(shk)*backLength;
    ankleX = kneeOffset.dx + math.cos(hka)*calfLength;
    ankleY = kneeOffset.dy + math.sin(hka)*calfLength;
    shoulderOffset = new Offset(shoulderX, shoulderY);
    ankleOffset = new Offset(ankleX, ankleY);
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


