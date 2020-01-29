import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    /*Text(
      'Index 0: Stats',
      style: optionStyle,
    ),*/
    FootPressureMap(),
    Text(
      'Index 1: Start Session',
      style: optionStyle,
    ),
    Text(
      'Index 2: Settings',
      style: optionStyle,
    ),
  ];

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
        title: const Text('nuCoach'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Stats'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            title: Text('Start Session'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_applications),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ), // This trailing comma makes auto-formatting nicer for build methods.
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