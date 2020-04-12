import 'package:flutter/material.dart';

class FootPressureMap extends StatelessWidget {
//  List<List<int>> fpreadings = [
//    [10, 10, 10, 10, 10],
//    [10, 3, 3, 3, 10],
//    [10, 3, 1, 3, 10],
//    [10, 3, 3, 3, 10],
//    [10, 10, 10, 10, 10],
//  ];

//  List<List<dynamic>> fpreadings = [
//    [77, 28, 22, 18, 16, 15, 13, 33, 23, 17, 15, 19, 19, 20, 23, 66, 47, 39, 45, 49, 45, 28, 38],
//    [28, 22, 1]
//  ]

  List<List<dynamic>> fpreadings;

  FootPressureMap(this.fpreadings);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
              border: Border.all(color: Colors.black, width: 2.0),
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
    if (fpreading <= 25) {
      return Container(
        color: Colors.indigo[900],
      );
    } else if (fpreading > 25 && fpreading <= 50) {
      return Container(
        color: Colors.indigo[700],
      );
    } else if (fpreading > 50 && fpreading <= 75) {
      return Container(
        color: Colors.deepPurple,
      );
    } else if (fpreading > 75 && fpreading <= 100) {
      return Container(
        color: Colors.purple[800],
      );
    } else if (fpreading > 100 && fpreading <= 125) {
      return Container(
        color: Colors.purple[600],
      );
    } else if (fpreading > 125 && fpreading <= 150) {
      return Container(
        color: Colors.purple,
      );
    } else if (fpreading > 150 && fpreading <= 175) {
      return Container(
        color: Colors.pink[700],
      );
    } else if (fpreading > 175 && fpreading <= 200) {
      return Container(
        color: Colors.pink,
      );
    } else if (fpreading > 200 && fpreading <= 225) {
      return Container(
        color: Colors.red[400],
      );
    } else {
      return Container(
        color: Colors.redAccent[400],
      );
    }
  }
}
