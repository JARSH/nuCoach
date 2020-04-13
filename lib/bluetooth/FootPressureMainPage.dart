import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:nucoach/bluetooth/FootPressureCollector.dart';
import 'package:nucoach/bluetooth/FootPressureCollectedPage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:nucoach/bluetooth/BluetoothHelper.dart';

import './DiscoveryPage.dart';
import './SelectBondedDevicePage.dart';
import './BackgroundCollectingTask.dart';
import './BackgroundCollectedPage.dart';

// import './helpers/LineChart.dart';

class FootPressureMainPage extends StatefulWidget {
  @override
  _FootPressureMainPage createState() => new _FootPressureMainPage();
}

class _FootPressureMainPage extends State<FootPressureMainPage> {
  final bluetoothHelper = BluetoothHelper.instance;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        bluetoothHelper.setBluetoothState(state);
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          bluetoothHelper.setAddress(address);
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        bluetoothHelper.setName(name);
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        bluetoothHelper.setBluetoothState(state);

        // Discoverable mode is disabled when Bluetooth gets disabled
        bluetoothHelper.setDiscoverableTimeoutTimer(null);
        bluetoothHelper.setDiscoverableTimeoutSecondsLeft(0);
      });
    });
  }

  @override
  void dispose() {
//    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
//    bluetoothHelper.getFootPressureCollector()?.dispose();
//    bluetoothHelper.getDiscoverableTimeoutTimer()?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Bluetooth Serial'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            SwitchListTile(
              title: const Text('Enable Bluetooth'),
              value: bluetoothHelper.getBluetoothState().isEnabled,
              onChanged: (bool value) {
                // Do the request and update with the true value then
                future() async {
                  // async lambda seems to not working
                  if (value)
                    await bluetoothHelper.requestEnable();
                  else
                    await bluetoothHelper.requestDisable();
                }

                future().then((_) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              title: const Text('Bluetooth status'),
              subtitle: Text(bluetoothHelper.getBluetoothState().toString()),
              trailing: RaisedButton(
                child: const Text('Settings'),
                onPressed: () {
                  bluetoothHelper.openSettings();
                },
              ),
            ),
            ListTile(
              title: const Text('Local adapter address'),
              subtitle: Text(bluetoothHelper.getAddress()),
            ),
            ListTile(
              title: const Text('Local adapter name'),
              subtitle: Text(bluetoothHelper.getName()),
              onLongPress: null,
            ),
            ListTile(
              title: const Text('Paired Device'),
              subtitle: Text(bluetoothHelper.getBluetoothDevice()?.name ??
                  "None or Unknown"),
              trailing: RaisedButton(
                child: const Text('Select Device'),
                onPressed: () async {
                  bluetoothHelper
                      .setBluetoothDevice(await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SelectBondedDevicePage(checkAvailability: false);
                      },
                    ),
                  ));

                  if (bluetoothHelper.getBluetoothDevice() != null) {
                    bluetoothHelper.setFootPressureCollector(
                        await FootPressureCollector.connect(bluetoothHelper.getBluetoothDevice()));
                  }
                },
              ),
            ),
            Divider(),
            ListTile(
                title:
                    const Text('Test: Connect to FP Sensor and Capture Data')),
            ListTile(
              title: RaisedButton(
                child: ((bluetoothHelper.getFootPressureCollector() != null && bluetoothHelper.getFootPressureCollector()?.inProgress != null)
                    ? const Text('Disconnect and stop background collecting')
                    : const Text('Connect to start background collecting')),
                onPressed: () async {
                  if (bluetoothHelper.getFootPressureCollector() != null && bluetoothHelper.getFootPressureCollector()?.inProgress != null) {
                    await bluetoothHelper.getFootPressureCollector().cancel();
                    setState(() {
                      /* Update for `_collectingTask.inProgress` */
                    });
                  } else {
                    final BluetoothDevice selectedDevice =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return SelectBondedDevicePage(
                              checkAvailability: false);
                        },
                      ),
                    );

                    if (selectedDevice != null) {
                      await _startBackgroundTask(context, selectedDevice);
                      setState(() {
                        /* Update for `_collectingTask.inProgress` */
                      });
                    }
                  }
                },
              ),
            ),
            ListTile(
              title: RaisedButton(
                child: const Text('View FP Data'),
                onPressed: (bluetoothHelper.getFootPressureCollector() != null)
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ScopedModel<FootPressureCollector>(
                                model: bluetoothHelper.getFootPressureCollector(),
                                child: FootPressureCollectedPage(),
                              );
                            },
                          ),
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startBackgroundTask(
    BuildContext context,
    BluetoothDevice server,
  ) async {
    try {
      bluetoothHelper.setFootPressureCollector(await FootPressureCollector.connect(server));
      bluetoothHelper.startFootPressureCollector();
    } catch (ex) {
      if (bluetoothHelper.getFootPressureCollector() != null) {
        bluetoothHelper.cancelFootPressureCollector();
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error occured while connecting'),
            content: Text("${ex.toString()}"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
