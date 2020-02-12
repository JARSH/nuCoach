import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
// import 'dart:math' as math;

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;

  Camera(this.cameras, this.setRecognitions);

  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
              // title: new Text("title"),
              content: new Text("Please position your camera to fit your full height in frame."),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
      );
    });

    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No camera is found');
    } else {
      controller = new CameraController(
        widget.cameras[1],
        ResolutionPreset.medium,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) {
          if (!isDetecting) {
            isDetecting = true;

            // int startTime = new DateTime.now().millisecondsSinceEpoch;

            var result = Tflite.runPoseNetOnFrame(
              bytesList: img.planes.map((plane) {return plane.bytes;}).toList(),
              imageHeight: img.height,
              imageWidth: img.width,
              numResults: 2,
            ).then((recognitions) {
              // int endTime = new DateTime.now().millisecondsSinceEpoch;
              // print("Detection took ${endTime - startTime}");

              widget.setRecognitions(recognitions, img.height, img.width);

              isDetecting = false;
            }
            );
            print(result);
          }
        });
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    // var tmp = MediaQuery.of(context).size;
    // var screenH = math.max(tmp.height, tmp.width);
    // var screenW = math.min(tmp.height, tmp.width);
    // tmp = controller.value.previewSize;
    // var previewH = math.max(tmp.height, tmp.width);
    // var previewW = math.min(tmp.height, tmp.width);
    // var screenRatio = screenH / screenW;
    // var previewRatio = previewH / previewW;

    return Scaffold(
      appBar: AppBar(
        title: Text('nuCoach'),
      ),
      body:// OverflowBox(
        // maxHeight:
        //     screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
        // maxWidth:
        //     screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
        /*child:*/ CameraPreview(controller//),
      ),
      floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.redAccent,
      onPressed: () {
        print('why?');
      },
      child: Icon(Icons.stop),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}