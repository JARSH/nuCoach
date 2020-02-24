import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nucoach/database/database_helpers.dart';
import 'package:nucoach/models/session.dart';
import 'package:nucoach/screens/summary/summary_widget.dart';
import 'package:tflite/tflite.dart';

enum ConfirmSave { DISCARD, KEEP, EXPORT }
enum MidSession { END, CONTINUE }

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  int totalReps = 0;
  int currentReps = 0; //completed in current set
  int currentSet = 1;
  String exerciseType = 'squats';

  Camera(this.cameras, this.setRecognitions);

  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController controller;
  bool isDetecting = false;
  Future<Session> session;

  //variables for rep detection
  var previousData;
  bool firstFrame = true;
  int referenceID; //ID of body part used as start/stop reference
  bool descending = true;

  var angleBuffer = [];
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();

    session = _querySessions();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
          // title: new Text("title"),
          content: new Text(
              "Please position your camera to fit full body in frame."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("DONE"),
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
        widget.cameras[0], //front facing camera = 1, rear camera = 0
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

            var result = Tflite.runPoseNetOnFrame(
              bytesList: img.planes.map((plane) {
                return plane.bytes;
              }).toList(),
              imageHeight: img.height,
              imageWidth: img.width,
              numResults: 2,
            ).then((recognitions) {
              var keyData = recognitions[0]['keypoints'];
              if (firstFrame) {
                //check scores of leftHip and rightHip, and decide which will be the reference
                if (recognitions[0]['keypoints'][11]['score'] >
                    recognitions[0]['keypoints'][12]['score']) {
                  //TODO: deal with exceptions
                  referenceID = 11;
                } else {
                  referenceID = 12;
                }
                firstFrame = false;
              } else {
                if (descending &&
                    (keyData[referenceID]['y'] >
                        previousData[referenceID]['y'])) {
                  descending = false;
                  //send previousData to a local buffer to be processed later
                  angleBuffer.add(previousData);
                  widget.currentReps++;
                } else if (!descending &&
                    (keyData[referenceID]['y'] <
                        previousData[referenceID]['y'])) {
                  descending = true;
                }
              }

              previousData = keyData;

              isDetecting = false;
            });
            //print(result);
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

  Future<Session> _querySessions() async {
    /*1. check if today already has a session
    2.if today's session exists, get the sessionID, otherwise insert a new session into database
    */
    Session session;
    DateTime now = new DateTime.now();
    DateTime today = new DateTime(now.year, now.month, now.day);
    var sessionResult = await dbHelper.fetchSessionByDate(today.toString());
    if (sessionResult == null) {
      Map<String, dynamic> row = {columnDate: today.toString()};
      session = Session.fromMap(row);
      session.id = await dbHelper.insertSession(row);
      session.sets = new List();
      return session;
    }
    return Session.fromMap(sessionResult);
  }

  void CalculateAngles() async {
    int shoulder, hip, knee, ankle;
    if (referenceID == 11) {
      shoulder = 5;
      hip = 11;
      knee = 13;
      ankle = 15;
    } else {
      shoulder = 6;
      hip = 12;
      knee = 14;
      ankle = 16;
    }
    // TODO: insert a set
    for (var angleData in angleBuffer) {
      //TODO: concurrent modification exception (growable list)
      double shoulderHip = math.sqrt(
          math.pow((angleData[shoulder]['x'] - angleData[hip]['x']), 2) +
              math.pow((angleData[shoulder]['y'] - angleData[hip]['y']), 2));
      double hipKnee = math.sqrt(
          (math.pow((angleData[hip]['x'] - angleData[knee]['x']), 2)) +
              math.pow((angleData[hip]['y'] - angleData[knee]['y']), 2));
      double kneeAnkle = math.sqrt(
          (math.pow((angleData[knee]['x'] - angleData[ankle]['x']), 2)) +
              math.pow((angleData[knee]['y'] - angleData[ankle]['y']), 2));
      double shoulderKnee = math.sqrt(
          (math.pow((angleData[shoulder]['x'] - angleData[knee]['x']), 2)) +
              math.pow((angleData[shoulder]['y'] - angleData[knee]['y']), 2));
      double hipAnkle = math.sqrt(
          (math.pow((angleData[hip]['x'] - angleData[ankle]['x']), 2)) +
              math.pow((angleData[hip]['y'] - angleData[ankle]['y']), 2));
      double shk = math.acos((math.pow(shoulderHip, 2) +
              math.pow(hipKnee, 2) -
              math.pow(shoulderKnee, 2)) /
          (2 * shoulderHip * hipKnee));
      double hka = math.acos((math.pow(hipKnee, 2) +
              math.pow(kneeAnkle, 2) -
              math.pow(hipAnkle, 2)) /
          (2 * hipKnee * kneeAnkle));
      Map<String, dynamic> row = {
        columnSetId: widget.currentSet,
        columnScore: 67, //DUMMY VALUE
        columnShk: shk,
        columnHka: hka,
      };
      await dbHelper.insertRep(row);
    }
  }

  Future<ConfirmSave> _asyncConfirmDialog(BuildContext context) async {
    return showDialog<ConfirmSave>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Keep recording?'),
          content: const Text(
              'Would you like to discard this recording, keep the data, or keep and export video to camera roll?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('DISCARD'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmSave.DISCARD);
              },
            ),
            FlatButton(
              child: const Text('KEEP'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmSave.KEEP);
              },
            ),
            FlatButton(
                child: const Text('KEEP AND EXPORT'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmSave.EXPORT);
                })
          ],
        );
      },
    );
  }

  Future<MidSession> _asyncMidSessDialog(BuildContext context) async {
    return showDialog<MidSession>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              'You just did ${widget.currentReps} reps of ${widget.exerciseType} and have done ${widget.totalReps} '
              '${widget.exerciseType} reps in total!'),
          actions: <Widget>[
            FlatButton(
              child: const Text('END SESSION'),
              onPressed: () {
                Navigator.of(context).pop(MidSession.END);
              },
            ),
            FlatButton(
              child: const Text('CONTINUE WORKING OUT'),
              onPressed: () {
                Navigator.of(context).pop(MidSession.CONTINUE);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return Scaffold(
      appBar: AppBar(
        title: Text('nuCoach'),
      ),
      body: OverflowBox(
        maxHeight: screenRatio > previewRatio
            ? screenH
            : screenW / previewW * previewH,
        maxWidth: screenRatio > previewRatio
            ? screenH / previewH * previewW
            : screenW,
        child: CameraPreview(controller),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () async {
          // open dialog to discard, keep, or keep and export data
          final ConfirmSave action = await _asyncConfirmDialog(context);
          print(action);
          if (action == ConfirmSave.KEEP || action == ConfirmSave.EXPORT) {
            print('data has been saved');
            // TODO: process local buffer of angles and send to database
            widget.totalReps += widget.currentReps;
            //repsPerSet.add(widget.currentReps);
            //store to database
            CalculateAngles();
            if (action == ConfirmSave.EXPORT) {
              print('recording has been exported');
              // TODO: export video
            }
            final MidSession next = await _asyncMidSessDialog(context);
            if (next == MidSession.END) {
              print('GET ME OUT');
              // Navigator to summary
              Get.to(SummaryWidget(await session));
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //   builder: (context) => CalendarWidget()) //TODO: change this to home widget
              // );
            } else {
              widget.currentReps = 0;
              widget.currentSet++;
              firstFrame = true;
            }
          }
        },
        child: Icon(Icons.stop),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
