import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nucoach/bluetooth/MainPage.dart';
import 'package:nucoach/components/database_test_widget.dart';


class SettingsWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(
                'Database',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Get.to(DatabaseTestWidget());
              },
            ),
            RaisedButton(
              child: Text(
                'Bluetooth',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Get.to(MainPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
