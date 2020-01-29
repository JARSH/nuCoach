import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  final Color color;
  final String text;
  final TextStyle style;

  PlaceholderWidget(this.color, this.text, this.style);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
