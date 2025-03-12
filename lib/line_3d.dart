// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'gl_script.dart' show glScript;
//import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//import '../widgets/characteristic_tile.dart';

class Graph extends StatefulWidget {
  final List<int> bleData; // Add BLE data parameter

  const Graph({super.key, required this.bleData});

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  List<List<double>> data = [
    [0, 0, 0],
    [1, 0, 0],
    [1, 0, 2],
    [0, 0, 2],
    [0, 0, 0],
    [0, 1, 0],
    [1, 1, 0],
    [1, 0, 0],
    [1, 0, 2],
    [1, 1, 2],
    [1, 1, 0],
    [0, 1, 0],
    [0, 1, 2],
    [0, 0, 2],
    [1, 0, 2],
    [1, 1, 2],
    [0, 1, 2]
  ];

  List<List<double>> data2 = [
    [0, 0, 0],
    [1, 0, 0],
    [1, 0, 2],
    [0, 0, 2],
    [0, 0, 0],
    [0, 1, 0],
    [1, 1, 0],
    [1, 0, 0],
    [1, 0, 2],
    [1, 1, 2],
    [1, 1, 0],
    [0, 1, 0],
    [0, 1, 2],
    [0, 0, 2],
    [1, 0, 2],
    [1, 1, 2],
    [0, 1, 2]
  ];

  @override
  void didUpdateWidget(Graph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bleData != oldWidget.bleData) {
      // Update data when BLE data changes
      _updateWithBleData();
    }
  }

  void _updateWithBleData() {
    // If BLE data contains at least one object
    if (widget.bleData.isNotEmpty) {
      List<List<double>> newData =
          data.map((e) => List<double>.from(e)).toList();
      List<List<double>> newData2 =
          data2.map((e) => List<double>.from(e)).toList();

      // Iterate through each embedded object in the BLE data
      if (widget.bleData.length >= 3) {
        for (int i = 0; i < widget.bleData.length; i += 3) {
          double x = widget.bleData[i].toDouble();
          double y = widget.bleData[i + 1].toDouble();
          double z = widget.bleData[i + 2].toDouble();

          // Apply offsets to new data (update the data based on x, y, z)
          updateData(newData, x, y, z);
          updateData(newData2, x, y, z);
        }
      }

      setState(() {
        data = newData;
        data2 = newData2;
      });
    }
  }

  void updateData(List<List<double>> data, double x, double y, double z) {
    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < data[i].length; j++) {
        if (data[i][j] == 2) {
          // Example condition, adjust as needed
          data[i][j] = z; // Apply z if condition is met
        }
        if (j == 0) {
          data[i][j] += x; // Add x offset
        }
        if (j == 1) {
          data[i][j] += y; // Add y offset
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String option = '''
    {
      "tooltip": {},
      "backgroundColor": "#fff",
      "visualMap": {
        "show": false,
        "dimension": 2,
        "min": 0,
        "max": 30,
        "inRange": {
          "color": [
            "#313695",
            "#4575b4",
            "#74add1",
            "#abd9e9",
            "#e0f3f8",
            "#ffffbf",
            "#fee090",
            "#fdae61",
            "#f46d43",
            "#d73027",
            "#a50026"
          ]
        }
      },
      "xAxis3D": {
        "type": "value",
        "min": -4.0,
        "max": 4.0
      },
      "yAxis3D": {
        "type": "value",
        "min": 0,
        "max": 8.0
      },
      "zAxis3D": {
        "type": "value",
        "min": 0,
        "max": 3.0
      },
      "grid3D": {
        "viewControl": {
          "projection": "orthographic"
        }
      },
      "series": [
        {
          "type": "line3D",
          "data": $data,
          "lineStyle": {
            "width": 4
          }
        },
        {
          "type": "line3D",
          "data": $data2,
          "lineStyle": {
            "width": 4,
            "color": "#ff5733"
          }
        }
      ]
    }
    ''';
    return Container(
      child: Echarts(
        extensions: [glScript],
        option: option,
      ),
      width: 300,
      height: 250,
    );
  }
}

// extension on int {
//   get length => null;
// }
