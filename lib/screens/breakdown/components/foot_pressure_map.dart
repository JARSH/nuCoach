import 'package:flutter/material.dart';

class FootPressureMap extends StatelessWidget {
//  List<List<int>> fpreadings = [
//    [10, 10, 10, 10, 10],
//    [10, 3, 3, 3, 10],
//    [10, 3, 1, 3, 10],
//    [10, 3, 3, 3, 10],
//    [10, 10, 10, 10, 10],
//  ];

  List<List> fpreadings;

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
    if (fpreading <= 1) {
      return Container(
        color: Colors.yellow,
      );
    } else if (fpreading > 1 && fpreading <= 5) {
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
