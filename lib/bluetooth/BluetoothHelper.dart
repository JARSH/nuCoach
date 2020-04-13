import 'dart:async';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:nucoach/bluetooth/FootPressureCollector.dart';


class BluetoothHelper {
  // make this a singleton class
  BluetoothHelper._privateConstructor();
  static final BluetoothHelper instance = BluetoothHelper._privateConstructor();
  // only have a single app-wide reference to the database
  static BluetoothHelper _bluetoothHelper;

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothDevice bluetoothDevice;
  FootPressureCollector _footPressureCollector;
  Timer _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  String _address = "...";
  String _name = "...";

  void setBluetoothState(BluetoothState bluetoothState) {
    _bluetoothState = bluetoothState;
  }

  String getAddress() {
    return _address;
  }

  void setAddress(String address) {
    _address = address;
  }

  String getName() {
    return _name;
  }

  void setName(String name) {
    _name = name;
  }

  Timer getDiscoverableTimeoutTimer() {
    return _discoverableTimeoutTimer;
  }

  void setDiscoverableTimeoutTimer(Timer timer) {
    _discoverableTimeoutTimer = timer;
  }

  void setDiscoverableTimeoutSecondsLeft(int secondsLeft) {
    _discoverableTimeoutSecondsLeft = secondsLeft;
  }

  BluetoothState getBluetoothState() {
    return _bluetoothState;
  }

  BluetoothDevice getBluetoothDevice() {
    return bluetoothDevice;
  }

  void setBluetoothDevice(BluetoothDevice bluetoothDevice) {
    this.bluetoothDevice = bluetoothDevice;
  }

  FootPressureCollector getFootPressureCollector() {
    return _footPressureCollector;
  }

  void setFootPressureCollector(FootPressureCollector footPressureCollector) {
    _footPressureCollector = footPressureCollector;
  }

  Future<void> startFootPressureCollector() async {
    await _footPressureCollector.start();
  }

  void cancelFootPressureCollector() {
    _footPressureCollector.cancel();
  }

  Future<void> requestEnable() async {
    await FlutterBluetoothSerial.instance.requestEnable();
  }

  Future<void> requestDisable() async {
    await FlutterBluetoothSerial.instance.requestDisable();
  }

  void openSettings() {
    FlutterBluetoothSerial.instance.openSettings();
  }

}