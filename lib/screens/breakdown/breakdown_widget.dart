import 'package:flutter/material.dart';
import 'package:nucoach/models/rep.dart';
import 'package:nucoach/screens/breakdown/components/cv_breakdown_widget.dart';
import 'package:nucoach/screens/breakdown/components/fp_breakdown_widget.dart';
import 'package:nucoach/screens/breakdown/components/overall_breakdown_widget.dart';

class Breakdown extends StatefulWidget {
  Breakdown(this.rep, {Key key}) : super(key: key);

  final Rep rep;

  @override
  _BreakdownState createState() => _BreakdownState();
}

class _BreakdownState extends State<Breakdown> {
  int _selectedIndex = 0;
  static List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      OverallBreakdown(widget.rep),
      CVBreakdown(widget.rep),
      FPBreakdown(widget.rep),
    ];
  }

  @override
  Widget build(BuildContext context) {
    print(widget.rep);
    print(widget.rep.score);
    print(widget.rep.angles.shk);
    print(widget.rep.angles.hka);
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
            icon: Icon(Icons.done),
            title: Text('Overall'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.visibility),
            title: Text('Computer Vision'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            title: Text('Foot Pressure'),
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
    });
  }
}
