import 'package:flutter/material.dart';
import 'package:nucoach/models/rep.dart';
import 'package:nucoach/screens/breakdown/components/cv_breakdown_widget.dart';
import 'package:nucoach/screens/breakdown/components/fp_breakdown_widget.dart';
import 'package:nucoach/screens/breakdown/components/overall_breakdown_widget.dart';

class Breakdown extends StatefulWidget {
  Breakdown({Key key, this.rep}) : super(key: key);

  final Rep rep;

  @override
  _BreakdownState createState() => _BreakdownState(rep);
}

class _BreakdownState extends State<Breakdown> {
  int _selectedIndex = 0;
  static Rep rep = new Rep();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _children = [
    OverallBreakdown(rep),
    CVBreakdown(rep),
    FPBreakdown(rep),
  ];

  _BreakdownState(rep) {
    _BreakdownState.rep = rep;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('nuCoach'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _children[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            title: Text('Overall Breakdown'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            title: Text('Computer Vision'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            title: Text('Foot Pressure'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
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
    });
  }
}
