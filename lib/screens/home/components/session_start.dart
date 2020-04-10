import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../camera/camera_widget.dart';

class Session extends StatefulWidget {
  final Color color;
  final String text;
  final TextStyle style;
  final List<CameraDescription> cameras;

  Session(this.color, this.text, this.style, this.cameras);

  @override
  SessionState createState() => new SessionState();
}

class SessionState extends State<Session> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        // print('you clicked me');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Camera(widget.cameras)),
        );
      },
      color: widget.color,
      child: Text(
        widget.text,
        style: widget.style,
        textAlign: TextAlign.center,
      ),
    );
  }
}
