import 'package:flutter/material.dart';

import 'home_widget.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Session {
  DateTime date;
  List<Set> sets;
}

class Set {
  Exercise exercise;
  int score;
  List<Rep> reps;
}

class Rep {
  int score;
  Angles angles;
  FootPressureMap fpmap;
}

class Angles extends StatelessWidget {
  int shk;
  int hka;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}

class FootPressureMap extends StatelessWidget {
  List<List<int>> fpreadings = [
    [10, 10, 10, 10, 10],
    [10, 3, 3, 3, 10],
    [10, 3, 1, 3, 10],
    [10, 3, 3, 3, 10],
    [10, 10, 10, 10, 10],
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Foot Pressure Map'),
      ),
      body: _buildFootPressureMap(),
    );
  }

  Widget _buildFootPressureMap() {
    int fpreadingsLength = fpreadings.length;
    int fpreadingsWidth = fpreadings[0].length;
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0)
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: fpreadingsLength,
              ),
              itemBuilder: _buildFootPressureMapItems,
              itemCount: fpreadingsLength * fpreadingsWidth,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFootPressureMapItems(BuildContext context, int index) {
    int fpreadingsLength = fpreadings.length;
    //int fpreadingsWidth = fpreadings[0].length;
    int x, y = 0;
    x = (index / fpreadingsLength).floor();
    y = index % fpreadingsLength;
    int fpreading = fpreadings[x][y];
    if(fpreading <= 1) {
      return Container(
        color: Colors.yellow,
      );
    } else if(fpreading > 1 && fpreading <= 5) {
      return Container(
        color: Colors.orange,
      );
    } else {
      return Container(
        color: Colors.red,
      );
    }
  }
}

enum Exercise {
  Squat,
  BenchPress
}