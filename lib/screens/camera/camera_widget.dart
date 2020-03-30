import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nucoach/database/database_helpers.dart';
import 'package:nucoach/models/session.dart';
import 'package:nucoach/enums/exercise.dart';
import 'package:nucoach/screens/summary/summary_widget.dart';
import 'package:tflite/tflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:io';

enum ConfirmSave { DISCARD, KEEP, EXPORT }
enum MidSession { END, CONTINUE }

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  int totalReps = 0;
  int currentReps = 0; //completed in current set
  String exerciseType = Exercise.Squat.toString();

  Camera(this.cameras, this.setRecognitions);

  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController controller;
  bool isDetecting = false;
  Future<Session> session;
  bool calculating = false;
  bool waiting = true;    //waiting for user to click "DONE"
  String videoPath;
  Directory dir;
  bool _cameraOn = true;  //allows the controller to be 'off' while midsession dialogs are displayed

  //variables for rep detection
  var previousData;
  bool firstFrame = true;
  int referenceID; //ID of body part used as start/stop reference
  bool descending = true; //TODO: should this be true initially?

  var angleBuffer = [];
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();

    session = _querySessions();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => new AlertDialog(
          // title: new Text("title"),
          content: new Text(
              "Please position your camera to fit full body in frame."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("DONE"),
              onPressed: () {
                waiting = false;
                //startVideoRecording();
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
        widget.cameras[1], //front facing camera = 1, rear camera = 0
        ResolutionPreset.medium,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) {
          if (!isDetecting && !calculating && !waiting) {
            isDetecting = true;

            if(firstFrame) {
              startVideoRecording();
            }

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
                if (keyData[11]['score'] > keyData[12]['score']) {
                  //TODO: deal with exceptions
                  referenceID = 11;
                } else {
                  referenceID = 12;
                }
                firstFrame = false;
              } else {
                if (descending &&
                    (keyData[referenceID]['y'] <        // top left is 0,0
                        previousData[referenceID]['y'])) {
                  descending = false;
                  //send previousData to a local buffer to be processed later
                  angleBuffer.add(previousData);
                  widget.currentReps++;   //moved to calculateAngles
                } else if (!descending &&
                    (keyData[referenceID]['y'] >
                        previousData[referenceID]['y'])) {
                  descending = true;
                }
              }
              previousData = keyData;
              isDetecting = false;
            });
            //print(result);
          }
          //isDetecting = false;
        });
      });
    }
  }

 Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      return null;
    }

    	
    // Do nothing if a recording is on progress
    if (controller.value.isRecordingVideo) {
      return null;
    }

    //final Directory extDir = await getApplicationDocumentsDirectory();
    //final String dirPath = '${extDir.path}/Movies/flutter_test';

    final Directory appDirectory = await getExternalStorageDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$videoDirectory/$currentTime.mp4';

    try {
      videoPath = filePath;
      dir = new Directory(videoDirectory);
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

  }

  // void onStartRecording() {
  //   startVideoRecording().then((String saveLocation) {
  //     if (mounted) setState(() {});
  //     if (saveLocation != null) showInSnackBar('Saving video to $saveLocation');
  //   });
  // }

  	
  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

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
    // else {
    //   session = Session.fromMap(sessionResult);
    //   widget.currentSet = session.sets.length;

    // }
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
    if (widget.currentReps != 0) {
      Session s = await session;
      Map<String, dynamic> row = {
        columnSessionId: s.id,
        columnExercise: widget.exerciseType,
        columnWeight: 45,
        columnScore: 95,
      };
      final id = await dbHelper.insertSet(row);
      for (var angleData in angleBuffer) {
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
          columnSetId: id,
          columnScore: 67, //DUMMY VALUE
          columnShk: shk,
          columnHka: hka,
        };
        //if (.17453 <= shk && shk <= 2.0944 && .0349066 <= hka && hka <= 2.0944) {//angles dont suck
          //in degrees, 10<shk<120 and 20<hka<120
          await dbHelper.insertRep(row);
          //widget.currentReps++;
        //}
      }
      angleBuffer = [];
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
                setState(() {
                  _cameraOn = true;
                });
                startVideoRecording();

                //TODO: should bring up alert dialog again here to reposition
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
        child: _cameraOn ? CameraPreview(controller) : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () async {
          //TODO: should turn off camera controller while asking for dialogs
          stopVideoRecording();
          setState(() {
            _cameraOn = false;
          });
          // open dialog to discard, keep, or keep and export data
          calculating = true;
          final ConfirmSave action = await _asyncConfirmDialog(context);
          if (action == ConfirmSave.KEEP || action == ConfirmSave.EXPORT) {
            CalculateAngles();
            widget.totalReps += widget.currentReps;
            if (action == ConfirmSave.EXPORT) {
              // TODO: check this line
              GallerySaver.saveVideo(videoPath);
            }
          }
          final MidSession next = await _asyncMidSessDialog(context);
          if (next == MidSession.END) {
            Session se = await session;
            Get.to(SummaryWidget(se));
          } else {
            widget.currentReps = 0;
            isDetecting = false;
            calculating = false;
          }
          //TODO: clear saved video from app storage somehow? (check this)
          dir.deleteSync(recursive: true);
        },
        child: Icon(Icons.stop),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
