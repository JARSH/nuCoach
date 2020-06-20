import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nucoach/components/database_test_widget.dart';
import 'package:nucoach/main.dart';
import 'package:nucoach/screens/home/components/analytics_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import 'components/calendar_widget.dart';
import 'components/session_start.dart';
import 'components/settings_widget.dart';
import '../camera/camera_widget.dart';

class Home extends StatefulWidget {
  final List<CameraDescription> cameras;

  Home(this.cameras, {Key key, this.title})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<PermissionGroup, PermissionStatus> permissions;
  int _selectedIndex;
  String _title;

  final List<Widget> _children = [
    CalendarWidget(),
//    AnalyticsWidget(),
    SettingsWidget()
  ];

  @override
  void initState() {
    super.initState();
    getPermission();
    _selectedIndex = 0;
    _title = 'nuCoach';
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Container(
        child: _children[_selectedIndex],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'New Workout',
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Camera(widget.cameras)),
          );
        }
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
//          new BottomNavigationBarItem(
//            icon: Icon(Icons.show_chart),
//            title: Text('Analytics'),
//          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black26,
        onTap: _onItemTapped,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _selectedIndex = index;
      switch(index) {
        case 0: { _title = 'nuCoach'; }
        break;
//        case 1: { _title = 'Analytics'; }
//        break;
        case 1: { _title = 'Settings'; }
      }
    });
  }

  void getPermission() async {
    permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.camera, PermissionGroup.storage]);
  }
}
