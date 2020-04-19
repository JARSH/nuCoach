import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';

class FootPressureCollector extends Model {
  static FootPressureCollector of(
    BuildContext context, {
    bool rebuildOnChange = false,
  }) =>
      ScopedModel.of<FootPressureCollector>(
        context,
        rebuildOnChange: rebuildOnChange,
      );

  final BluetoothConnection _connection;

  // @TODO , Such sample collection in real code should be delegated
  // (via `Stream<DataSample>` preferably) and then saved for later
  // displaying on chart (or even stright prepare for displaying).
  // @TODO ? should be shrinked at some point, endless colleting data would cause memory shortage.

  static int row = 24;
  static int col = 24;
  List<int> _buffer = List<int>();
  List<int> list = List<int>();

  int index = 0;
  int r = 0;
  int c = 0;
  List<List<int>> matrix = List.generate(row, (i) => List(col), growable: false);

  bool inProgress;

  FootPressureCollector._fromConnection(this._connection) {
    _connection.input.listen((data) {
      _buffer += data;

      while (true) {
        if (_buffer.length - index > 0 && r < 24 && c < 24) {
          matrix[r][c] = _buffer[index];
          if (c == 23) {
            r++;
            c = 0;
          } else {
            c++;
          }
          index++;
        } else {
          break;
        }
      }
      notifyListeners();
    }).onDone(() {
      inProgress = false;
      notifyListeners();
    });
  }

  static Future<FootPressureCollector> connect(BluetoothDevice server) async {
    final BluetoothConnection connection =
        await BluetoothConnection.toAddress(server.address);
    return FootPressureCollector._fromConnection(connection);
  }

  void dispose() {
    _connection.dispose();
  }

  Future<void> start() async {
    inProgress = true;
//    _buffer.clear();
//    samples.clear();

//    for (int i = 0; i < matrix.length; i++) {
//      for (int j = 0; j < matrix[0].length; j++) {
//        matrix[i][j] = null;
//      }
//    }

    notifyListeners();
    _connection.output.add(ascii.encode('b'));
    await _connection.output.allSent;
  }

  Future<void> cancel() async {
    inProgress = false;
    notifyListeners();
    _connection.output.add(ascii.encode('s'));
    await _connection.finish();
  }

  Future<void> pause() async {
    inProgress = false;
    notifyListeners();
    _connection.output.add(ascii.encode('stop'));
    await _connection.output.allSent;
  }

  Future<void> reasume() async {
    inProgress = true;
    notifyListeners();
    _connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;
  }

  Future<List<List<int>>> getMatrixFuture() async {
    return matrix;
  }

  List<List<int>> getMatrix() {
    return matrix;
  }
}
